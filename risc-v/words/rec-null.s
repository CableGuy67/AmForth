
DATA "rectype-null", RECTYPE_NULL
    .word XT_FAIL  
    .word XT_FAIL  
    .word XT_FAIL  

COLON Flag_visible, "fail", FAIL
    .word XT_DOLITERAL
    .word -13
    .word XT_THROW
