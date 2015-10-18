\ #require count.frt
\ #require search-name.frt

\ a magic number, check LST file for
\ the actual value!
$48 constant 'ORDER

: (find-name) (addr len wid -- addr len 0 | nt -1 )
  >r 2dup r> search-name dup if nip nip then ;
 
: find-name ( addr len --  nt|0 ) 
  ['] (find-name) 'ORDER map-stack
;
