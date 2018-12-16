
COLON "rec-trace", REC_TRACE

    .word XT_DROP, XT_TO_R
    STRING " | "
    .word XT_R_FROM,XT_SOURCE,XT_PLUS,XT_OVER
    .word XT_MINUS,XT_TYPE,XT_CR
    .word XT_RECTYPE_NULL
    .word XT_EXIT
