\ Port Extender Access
\ Port Extender (e.g. PCF8574) usually
\ use addresses between $30 and $3f
\ check i2c.detect output

\ #require i2c.frt

\ write one byte to the PE
: i2c.pe.c! ( n hwid -- )
  1 swap i2c.n> ( --  )
;

\ get one byte from the PE
: i2c.pe.c@ ( hwid -- )
  1 swap i2c.>n
;

