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

$10 buffer: i2c-buffer \ must not change $10
variable i2c-in
variable i2c-out

: _wrap ( addr -- n )
  dup c@ ( -- addr n )
  dup 0 $0f within if 1+ else drop 0 then
  dup rot c!
;

: >i2c-buffer ( c -- )
    i2c-buffer i2c-in _wrap + c!
;

: i2c-buffer> ( -- c )
    i2c-buffer i2c-out _wrap + c@
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

: i2c.data.send ( -- ) 
  i2c-buffer> TWDR c!
  i2c.slave.twcr.ack
;

: i2c.slave.isr ( -- )
    TWSR c@
    \ receiving data
    dup $60 = if drop i2c.addr.ack exit then \ TW_SR_SLA_ACK
    dup $80 = if drop i2c.data.ack exit then \ TW_SR_SLA_ACK
    dup $88 = if drop i2c.data.nack exit then  \ TW_SR_SLA_NACK
    \ sending data
    dup $a8 = if drop i2c.data.send exit then \ TW_ST_SLA_ACK
    dup $b8 = if drop i2c.data.send exit then \ TW_ST_DATA_ACK
    drop i2c.slave.twcr.reset
;

' i2c.slave.isr decimal  TWIAddr int!
$42 i2c.slave.init
