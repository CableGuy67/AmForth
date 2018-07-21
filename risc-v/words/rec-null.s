
CONSTANT "rectype-null", RECTYPE_NULL
    .word XT_FAIL  # interpret
    .word XT_FAIL  # compile
    .word XT_FAIL  # postpone

COLON Flag_visible, "fail", FAIL
    .word XT_DOLITERAL
    .word -13
    .word XT_THROW
