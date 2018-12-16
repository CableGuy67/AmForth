COLON "rec-split", REC_SPLIT
    .word XT_RECTYPE_SPLIT
    .word XT_EXIT

DATA "rectype-split", RECTYPE_SPLIT
    .word XT_SPLIT  
    .word XT_SPLIT  
    .word XT_SPLIT  

COLON "split", SPLIT
    .word XT_DOTS,XT_CR,XT_TYPE,XT_CR
    .word XT_EXIT
