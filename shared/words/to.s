
IMMED "to", TO
    .word XT_TICK
    .word XT_TO_BODY
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH, PFA_TO1
    .word XT_COMPILE
    .word XT_DOTO2
    .word XT_COMMA
    .word XT_EXIT

NONAME DOTO2

    .word XT_R_FROM
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R
    .word XT_FETCH
PFA_TO1:
    .word XT_DUP, XT_FETCH,XT_SWAP
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_EXECUTE
    .word XT_EXIT
