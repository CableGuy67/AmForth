\ basic I2C operations, uses 7bit bus addresses
\ uses the TWI module of the Atmega's.
\ #require builds.frt
\ #require bitnames.frt

\ low level driver words
\ #require i2c-twi.frt

\ provides public commands

\  i2c.begin         -- starts a I2C bus cycle
\  i2c.end           -- ends a I2C bus cycle
\  i2c.n>            -- send n bytes to device   (n> means from data stack)
\  i2c.>n            -- read n bytes from device (>n means to data stack)

\ convert the bus address into a sendable byte
\ the address bits are the upper 7 ones,
\ the LSB is the read/write bit.

: i2c.wr 2* ;
: i2c.rd 2* 1+ ;

\ aquire the bus and select a device
\ start a write transaction
: i2c.begin ( hwid -- )
  dup i2c.current !
  i2c.start i2c.wr i2c.tx
;

\ start a read transaction
: i2c.begin-read ( hwid -- )
  dup i2c.current !
  i2c.start i2c.rd i2c.tx
;

\ release the bus and deselect the device
: i2c.end ( -- )
  i2c.stop
  0 i2c.current !
;

\ tranfser data from/to data stack

\ send n bytes to addr
: i2c.n> ( xn .. x1 N addr -- )
  i2c.begin
    0 ?do     \ uses N
      i2c.tx  \ send x1 ... xn
    loop
  i2c.end
;

: i2c.>n ( n addr -- x1 .. xn )
  i2c.begin-read
    1- 0 max 0 ?do i2c.rx loop i2c.rxn
  i2c.end
;

\ complex and flexible transaction word
\ send m bytes x1..xm and fetch n bytes y1..yn afterwards
: i2c.m>n ( n xm .. x1 m addr -- x1 .. xn )
  dup >r i2c.begin
    0 ?do i2c.tx loop \ send m bytes
    i2c.restart       \ repeated start
    r> i2c.rd i2c.tx  \ re-send addr, switch to read mode
    1- 0 max 0 ?do i2c.rx loop i2c.rxn \ read x1 .. xn
  i2c.end
;
