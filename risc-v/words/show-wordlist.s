
COLON Flag_visible, "show-wordlist", SHOWWORDLIST
    .word XT_DOLITERAL
    .word XT_SHOWWORD
    .word XT_SWAP
    .word XT_TRAVERSEWORDLIST
    .word XT_EXIT

    HEADLESS SHOWWORD
    .word XT_NAME2STRING
    .word XT_TYPE
    .word XT_SPACE
    .word XT_TRUE
    .word XT_EXIT
