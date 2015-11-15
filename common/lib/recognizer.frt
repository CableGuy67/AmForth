\ common recognizer words
\
\ platform specific code, selected via include directory
\ #include recognizer-arch.frt
\
\ build the methods table for a recognizer
: recognizer: ( interpret-xt compile-xt postpone-xt "name" -- )
   create swap rot , , , 
;

\ get and set the stack content
: set-recognizers set-stack ;
: get-recognizers get-stack ;

\ usage see Recognizer Recipes
