
: int? SREG c@ SREG_I and 0> ;

: critical[
    r> int? >r >r \ keep the current state
    -int 
;

: ]critical
    r> r> if +int then >r \ will crash if not matched
;

: bar ." bar" int? . ;
: baz ." baz" int? . ;
: qux ." qux" int? . ;

: foo 
  bar
  critical[ 
    \ nothing will disturb us here
    baz 
  ]critical \ now interrupts or other things may happen again
  qux ;
