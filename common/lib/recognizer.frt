
\ build the methods table for a recognizer
: recognizer: ( interpret-xt compile-xt postpone-xt "name" -- )
   create swap rot , , , 
;

\ get and set the stack content
: set-recognizers cfg-recs set-stack ;
: get-recognizers cfg-recs get-stack ;

\ usage see Recognizer Recipes
