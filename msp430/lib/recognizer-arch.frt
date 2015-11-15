
\ platform specific recognizer code

\ not saved to info flash.
: recognizer ( size -- )
   1+ here swap allot dup 0 ! 
;
