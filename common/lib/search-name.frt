
\ just like search-wordlist
\ searches a given wordlist for a word and returns its
\ name token (NT) or 0 if not found.
\

\ helper words
: isword? ( addr len flag nt -- addr len false | nt true )
  >r drop 2dup r@ name>string icompare if
    r> drop 0 -1
  else
    2drop r> 0
  then ;

\ the analogon to search-wordlist
: search-name ( addr len wid -- nt | 0 )
  >r 0 ['] isword? r> traverse-wordlist
  dup 0= if
   2drop drop 0
  then
;
