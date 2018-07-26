
DEFER "refill", REFILL
.word XT_REFILLTIB

COLON Flag_visible, "refill-tib", REFILLTIB

    .word XT_TIB
    .word XT_DOLITERAL
    .word refill_buf_size
    .word XT_ACCEPT
    .word XT_NUMBERTIB
    .word XT_STORE
    .word XT_ZERO
    .word XT_TO_IN
    .word XT_STORE
    .word XT_TRUE 
    .word XT_EXIT
