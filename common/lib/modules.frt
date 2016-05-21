\ VFX like modules based on Forth-94 wordlists      uho 2016-04-16
\ ----------------------------------------------------------------
\ #require set-order.frt
\ #require get-order.frt

: module ( <name> -- old-current )
    get-current  wordlist create dup >r , 
    get-order r@ swap 1+ set-order 
    r> set-current ;

: export ( <name> old-current -- old-currrent ) 
    >r >in @  '  swap >in !  get-current r@ set-current
    create swap , set-current r>
    does> @ execute ;

: expose-module ( <name> -- )
    get-order  ' >body @  swap 1+ set-order ;

: end-module ( old-current -- )
    set-current get-order nip 1- set-order ;
