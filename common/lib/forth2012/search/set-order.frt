\ set a new ORDER stack

: set-order
   dup 0= if -50 throw then \ no empty search order stack
   cfg-order set-stack
;