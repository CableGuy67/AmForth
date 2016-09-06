\ the following code is work in progress.
\ debug output and other oddities are possible
\



TWCR_TWEN TWCR_TWIE TWCR_TWINT or or constant TWCR_TWENALL

\ set the hw address and start the receiver
: i2c.slave.init ( hwid -- )
  2* \ see datasheet
  TWAR c!
  [ TWCR_TWENALL TWCR_TWEA or ] literal TWCR c!
;

: i2c.slave.twcr.ack
  [ TWCR_TWENALL TWCR_TWEA or ] literal TWCR c!
;
: i2c.slave.twcr.nack
  [ TWCR_TWENALL ] literal TWCR c!
;

: i2c.slave.twcr.reset
  [ TWCR_TWENALL TWCR_TWEA TWCR_TWSTO or or  ] literal TWCR c!
;

\ own address received with ACK
: i2c.addr.ack ( -- ) 
  \ well, nothing to do
  i2c.slave.twcr.ack
; 

\ #require buffer.frt

$10 buffer: i2c-buffer
variable i2c-in

: >i2c-buffer ( c -- )
    i2c-buffer i2c-in @ dup >r + c!
    r> 1+ $0f and i2c-in !
;

\ data received with NACK, probably the last one
: i2c.data.nack ( -- ) 
  TWDR c@ >i2c-buffer
  i2c.slave.twcr.nack
;
\ data received with ACK, more to follow
: i2c.data.ack ( -- ) 
  TWDR c@ >i2c-buffer
  i2c.slave.twcr.ack
;

variable debug
variable debug2

: i2c.slave.isr ( -- )
    1 debug +!
    TWSR c@
    $f8 and dup debug2 !
    \ receiving data
    dup $60 = if drop i2c.addr.ack exit then
    dup $80 = if drop i2c.data.ack exit then
    dup $88 = if drop i2c.data.nack exit then 
    drop i2c.slave.twcr.reset
;

decimal
' i2c.slave.isr TWIAddr int!
$42 i2c.slave.init
debug @ .
