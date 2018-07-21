
COLON Flag_visible, ".ok", PROMPTOK
    .word XT_DOSLITERAL
    .byte 3
    .ascii " ok"
    .p2align 2
    .word XT_TYPE
    .word XT_EXIT
