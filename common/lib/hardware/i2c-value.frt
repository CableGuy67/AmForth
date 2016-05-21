\
\ an I2C value
\


#require value.frt
#require quotations.frt
#require ms.frt
#require i2c.frt

\ fetch a byte from a byte addr
: c@i2c ( addr hwid -- c )
   dup i2c.begin
     swap i2c.tx
     i2c.rd i2c.tx
     i2x.rx
   i2c.end
;

\ fetch n bytes from a byte addr
: n_c@i2c ( n addr hwid -- c_n .. c_1 )
   dup i2c.begin
     swap i2c.tx
     i2c.rd i2c.tx
     -1 0 ?do i2c.rx loop i2c.rxn
   i2c.end
;

\ store a byte to a byte addr
: c!i2c ( c addr hwid -- )
   i2c.begin
     i2c.tx
     i2x.tx
   i2c.end
;

\ initial addr hwid ...
\ 17      0    $50  i2c.value "name"
: i2c.cvalue ( n addr hwid -- )
    (value)
    over , \ store the addr
    [: dup @i ( addr ) swap 3 + @i ( hwid) c@i2c ;] , 
    [: dup @i ( addr ) swap 3 + @i ( hwid) c!i2c 5 ms ;] ,
    dup ,  \ store hwid
    c!i2c  \ store inital data
;

