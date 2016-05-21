\ basic I2C operations, uses 7bit bus addresses
\ pure software bit bang I2c. Should be used together
\ with I2C-TWI (duplicate names)

#require bitnames.frt

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
\  i2c.ping?         -- checks if addr is a device

\ ******************** untested so far *******************
: tick ; \ highly CPU frequency dependend

PORTA 1 portpin: SCL
PORTB 7 portpin: SDA

: sda0 SDA low  ;
: sda1 SDA high ;
: scl0 SCL low  ;
: scl1 SCL high ;

: bit>i2c 
  if sda1 else sda0 then
  tick scl1 tick tick scl 0 tick
;

: i2c>bit SDA is_high? if 1 else 0 then ;

: i2c.start
   tick sda0 tick tick scl0 tick ;
: i2c.stop
   tick scl1 tick tick sda1 tick ;

>SDA - write to pin
SDA> - read from pin
SCL-0 - SCL low
SCL-1 - SCL high
half  - half cycle delay

: i2c.start
  1 >SDA half SCL-1 half 0 >SDA SCL-0
;

: i2c.stop
  0 >SDA half SCL-1 half 1 >SDA half
;

: i2x.tx.bit ( b -- nak ) 
   0<> >SDA half SCL-1 half SCL-0 ;
: i2c.rx.bit ( -- b) 
   1 >SDA half SCL-1 half SDA> SCL-0 ;

: i2c.tx ( n -- )
  8 0 do dup 128 and i2c.tx.bit 2* loop
  drop i2x.rx.bit
;
: i2c.rx ( nak -- n ) 
  0 8 0 do 2* i2c.rx.bit + loop swap i2c.tx.bit
;
