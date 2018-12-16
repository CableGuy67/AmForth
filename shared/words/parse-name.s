
COLON "parse-name", PARSENAME
    .word XT_BL
    .word XT_SKIPSCANCHAR
    .word XT_EXIT 

NONAME SKIPSCANCHAR
    .word XT_TO_R
    .word XT_SOURCE 
    .word XT_TO_IN 
    .word XT_FETCH 
    .word XT_SLASHSTRING 

    .word XT_R_FETCH
    .word XT_CSKIP
    .word XT_R_FROM
    .word XT_CSCAN

    .word XT_2DUP
    .word XT_PLUS
    .word XT_SOURCE 
    .word XT_DROP
    .word XT_MINUS
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT
