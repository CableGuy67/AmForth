
VARIABLE "hld", HLD

COLON Flag_visible, "hold", HOLD
    .word XT_HLD, XT_DUP, XT_FETCH
    .word XT_1MINUS, XT_DUP, XT_TO_R
    .word XT_SWAP, XT_STORE, XT_R_FROM
    .word XT_CSTORE, XT_EXIT
