
\ prepend -> to a value name and act like TO
\   42 to answer 
\ is the same as 
  \ 42 ->answer
\ The -> should be made a synonymous to TO
\
\ actions
:noname defer! ;
:noname postpone literal postpone defer! ;
:noname postpone 2literal ;
rectype: rectype-parsed-to

: rec-parsed-to ( addr len -- xt rectype-parsed-to | rectype-null )
   over @ $3e2d = ( -> ) 0= if 2drop rectype-null exit then
   \ something left?
   2 /string dup 0= if 2drop rectype-null exit then
   \ search for the name
   find-name 0= if rectype-null exit then
   ( -- xt )
   rectype-parsed-to
;
