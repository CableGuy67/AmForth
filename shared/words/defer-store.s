
COLON Flag_visible, "defer!", DEFERSTORE
    .word XT_TO_BODY
    .word XT_DUP, XT_FETCH,XT_SWAP
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_EXECUTE
    .word XT_EXIT

