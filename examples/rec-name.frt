
\ #require recognizer.frt
\ #require find-name.frt

\ from forth 2012
:noname name>interpret execute ;
:noname name>compile execute ;
:noname postpone literal ;
rectype: rectype-nt

\ the parsing word
: rec-nt ( addr len -- nt rectype-nt | rectype-null )
    find-name ?dup
    if rectype-nt else rectype-null then
;

\ replace rec-word with rec-name
\ everthing else should work as before
