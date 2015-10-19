\ remove the first entry in the search order list

\ #require get-order.frt
\ #require set-order.frt

: previous
  get-order nip 1-
  dup 0= if -50 throw then \ empty search order stack
  set-order
;
