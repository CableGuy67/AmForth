
\ #require compile-comma.frt
:noname name>interpret execute ;
:noname name>compile execute ;
:noname name>compile swap postpone literal compile, ;
recognizer: r:name

: isword? ( addr len flag nt -- addr len false | nt true )
  >r drop 2dup r@ name>string icompare if
    r> drop 0 true 
  else
    2drop r> 0
  then ;

: search-name ( addr len wid -- nt | 0 )
  >r 0 ['] isword? r> traverse-wordlist
  dup 0= if
   2drop drop 0
  then
;

\ order not yet
: rec:name ( addr len -- NT r:name | r:fail )
    get-current search-name if r:name else r:fail then
;

\ may replace rec:word
