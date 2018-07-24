COLON Flag_visible, ".error", PROMPTERROR
    .word XT_DOSLITERAL
    .byte 4
    .ascii " ?? "
    .p2align 2
    .word XT_TYPE
    .word XT_BASE
    .word XT_FETCH
    .word XT_TO_R
    .word XT_DECIMAL
    .word XT_DOT
    .word XT_TO_IN
    .word XT_FETCH
    .word XT_DOT
    .word XT_R_FROM
    .word XT_BASE
    .word XT_STORE
    .word XT_EXIT
