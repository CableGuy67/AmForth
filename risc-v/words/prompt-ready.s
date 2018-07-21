
COLON Flag_visible, ".ready", PROMPTREADY

    .word XT_DOSLITERAL, 2
    .ascii "> "
    .p2align 2
    .word XT_CR
    .word XT_TYPE
    .word XT_EXIT
