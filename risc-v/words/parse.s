
COLON Flag_visible, "parse", PARSE
    .word XT_TO_R 
    .word XT_SOURCE
    .word XT_TO_IN 
    .word XT_FETCH
    .word XT_SLASHSTRING 

    .word XT_R_FROM
    .word XT_CSCAN 
    .word XT_DUP   
    .word XT_1PLUS
    .word XT_TO_IN 
    .word XT_PLUSSTORE
    .word XT_DOLITERAL,1
    .word XT_SLASHSTRING
    .word XT_EXIT
