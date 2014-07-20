\ basic I2C operations, uses 7bit bus addresses
\ uses the TWI module of the Atmega's.

#require bitnames.frt
#require value.frt

\ provides
\  i2c.init          -- initialize i2c subsystem
\  i2c.init.default  -- some default settings
\  i2c.off           -- turns off i2c subsystem
\
\  i2c.wait          -- wait for the current i2c transaction
\  i2c.start         -- send start condition
\  i2c.stop          -- send stop condition
\  i2c.tx            -- send one byte
\  i2c.rx            -- receive one byte with ACK
\  i2c.rxn           .. receive one byte with NACK
\  i2c.status        -- get the last i2c status
\  i2c.wr            -- convert addr to sendable byte for writing
\  i2c.rd            -- convert addr to sendable byte for reading
\  i2c.ping?         -- checks if addr is a device

\  i2c.begin         -- starts a I2C bus cycle
\  i2c.end           -- ends a I2C bus cycle
\
\ i2c (SCL) clock speed = CPU_clock/(16 + 2*bitrateregister*(4^prescaler))
\ following the SCL clock speed in Hz for an 8Mhz device
\                     f_cpu   8000000
\      bitrate register (may be any value between 0 and 255)
\               4      8       16      32      64      128    255
\      prescaler                             
\      0     333.333 250.000 166.667 100.000 55.556  29.412  15.209
\      1     166.667 100.000 55.556  29.412  15.152  7.692   3.891
\      2     55.556  29.412  15.152  7.692   3.876   1.946     978
\      3     15.152  7.692   3.876   1.946     975     488     245
\
\

-4000 constant i2c.timeout  \ exception number for timeout
10000 Evalue   i2c.maxticks \ # of checks until timeout is reached
variable i2c.loop           \ timeout counter
variable i2c.current        \ current hwid if <> 0

: i2c.timeout?
    i2c.loop @ 1- dup i2c.loop ! 0=
;

\ turn off i2c
: i2c.off ( -- )
    0 TWCR c!
    0 i2c.current !
;

0 constant i2c.prescaler/1
1 constant i2c.prescaler/4
2 constant i2c.prescaler/16
3 constant i2c.prescaler/64
TWSR $3 bitmask: i2c.conf.prescaler

TWCR 7 portpin: i2c.int
TWCR 6 portpin: i2c.ea
TWCR 5 portpin: i2c.sta

\ enable i2c
: i2c.init ( prescaler bitrate  -- )
    i2c.off   \ stop i2c, just to be sure
    TWBR c!   \ set bitrate register
    i2c.conf.prescaler pin! \ the prescaler has only 2 bits
;

\ a very low speed initialization.
: i2c.init.default
    i2c.prescaler/64 3 i2c.init 
;

\ convert the bus address into a sendable byte
\ the address bits are the upper 7 ones,
\ the LSB is the read/write bit.

: i2c.wr 2* ;
: i2c.rd 2* 1+ ;

\ wait for i2c finish
: i2c.wait ( -- )
    i2c.maxticks i2c.loop !
    begin
       pause \ or 1ms?
       i2c.int is_high?
       i2c.timeout? if i2c.timeout throw then
    until
;

\ send start condition
: i2c.start ( -- )
    %10100100 TWCR c!
    i2c.wait
;

\ send stop condition
: i2c.stop ( -- )
    %10010100 TWCR c!
    \ no wait for completion.
;



\ process the data
: i2c.action
    %10000100 or TWCR c! \ _BV(i2cNT)|_BV(TWEN)
    i2c.wait
;

\ send 1 byte
: i2c.tx ( c -- )
    TWDR c!
    0 i2c.action
;

\ receive 1 byte, send ACK
: i2c.rx ( -- c )
    %01000000 \ TWEA
    i2c.action
    TWDR c@
;

\ receive 1 byte, send NACK
: i2c.rxn ( -- c )
    0 i2c.action
    TWDR c@
;

\ get i2c status
: i2c.status ( -- n )
    TWSR c@
    $f8 and
;

\ aquire the bus and select a device
: i2c.begin ( hwid -- )
  dup i2c.current !
  i2c.start i2c.wr i2c.tx
;
\ release the bus and deselect the device
: i2c.end ( -- )
  i2c.stop
  0 i2c.current !
;

\ detect presence of a device on the bus
: i2c.ping?   ( addr -- f )
    i2c.start 
    i2c.wr i2c.tx
    i2c.status $18 =
    i2c.stop
;
