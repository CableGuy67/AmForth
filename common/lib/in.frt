\ invented at the Euro Forth 2016 to
\ define a word in a vocabulary different
\ to CURRENT

\ #require also.frt
\ #require previous.frt
\ #require definitions.frt


: in ( "voc" "defining-word" -- )
    get-current >r also ' execute 
    definitions previous ' execute r> set-current 
;

\ use as follows, require vocabulary.frt first
\ vocabulary gui
\ in gui : foo ( .. -- .. ) ... ;
\ in gui variable bar
\ in gui defer baz 
\
