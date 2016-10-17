\
\ separate stacks for cell sized data
\ the build words use the EEPROM for
\ storing the data, this code uses
\ the RAM instead. Names are the same
\ however, use of a separate wordlist
\ is recommended.
\
\ Date: Oct 15, 2016
\ Author: Matthias Trute
\ with ideas from Jenny Brien

\ allocate a stack region with at most 
\ size elements
: stack ( size -- stack-id )
  1+ ( size ) cells here swap allot
  0 over ! \ empty stack
;

\ replace the stack content with data from
\ the data stack.
: set-stack ( rec-n .. rec-1 n recstack-id -- )
  2dup ! cell+ swap cells bounds 
  ?do i ! cell +loop
;

\ read the whole stack to the data stack
: get-stack ( recstack-id -- rec-n .. rec-1 n )
  dup @ >r R@ cells + r@ begin 
    ?dup 
  while
    1- over @ rot cell - rot
  repeat 
  drop r>
;

\ execute XT for earch element of the stack
\ leave the loop if the XT returns TRUE
: map-stack ( i*x XT stack-id -- j*y f )
   dup cell+ swap @ cells bounds ?do 
     i @ swap dup >r execute
     ?dup if r> drop unloop exit then
     r> cell +loop 
   drop 0
;

\ add an item as new top of the stack
: >front ( x stack-id -- )
  2dup 2>r nip get-stack 2r> rot 1+ swap set-stack
;

\ add an item at the bottom of a stack
: >back ( x stack-id -- )
  dup >r get-stack 1+ r> set-stack
;

\ ------------- Test Cases ------------

4 stack constant test

: s1 1 0 ; \ 0 means continue with map-stack
: s2 2 0 ;
: s3 3 0 ;
: s4 4 -1 ; \ -1 means premature exit from map-stack

\ set and get methods
T{ 0 test set-stack -> }T
T{ test get-stack -> 0 }T

T{ ' s1 1 test set-stack -> }T
T{ test get-stack -> ' s1 1 }T

T{ ' s2 ' s1 2 test set-stack -> }T
T{ test get-stack -> ' s2 ' s1 2 }T

T{ ' s1 ' s2 ' s3 3 test set-stack -> }T
T{ test get-stack -> ' s1 ' s2 ' s3 3 }T

\ testing map-stack
\ the whole stack is used for execute
T{ ' execute test map-stack -> 3 2 1 0 }T

T{ ' s1 ' s2 ' s4 3 test set-stack -> }T
\ only the 1st element is executed
T{ ' execute test map-stack -> 4 -1 }T

\ append and prepend methods
T{ ' s1 1 test set-stack -> }T
T{ ' s2 test >front -> }T
T{ test get-stack -> ' s1 ' s2 2 }T

T{ ' s1 1 test set-stack -> }T
T{ ' s2 test >back -> }T
T{ test get-stack -> ' s2 ' s1 2 }T
