
COLON Flag_visible, "rec-find", REC_FIND
    .word XT_FINDXT
    .word XT_DUP
    .word XT_ZEROEQUAL, XT_DOCONDBRANCH, PFA_REC_WORD_FOUND
        .word XT_DROP
	.word XT_RECTYPE_NULL
	.word XT_EXIT
PFA_REC_WORD_FOUND:
    .word XT_RECTYPE_XT

    .word XT_EXIT

CONSTANT "rectype-xt", RECTYPE_XT
    .word XT_R_WORD_INTERPRET
    .word XT_R_WORD_COMPILE
    .word XT_2LITERAL

HEADLESS R_WORD_INTERPRET
    .word XT_DROP 
    .word XT_EXECUTE
    .word XT_EXIT

HEADLESS R_WORD_COMPILE
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH,PFA_R_WORD_COMPILE1
	.word XT_COMMA
        .word XT_EXIT
PFA_R_WORD_COMPILE1:
        .word XT_EXECUTE
    .word XT_EXIT
