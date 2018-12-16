
COLON ".s", DOTS

    .word XT_DEPTH
    .word XT_UDOT
    .word XT_SPACE
    .word XT_DEPTH
    .word XT_ZERO
    .word XT_QDOCHECK, XT_DOCONDBRANCH,PFA_DOTS2
    .word XT_DODO
PFA_DOTS1:
    .word XT_I
    .word XT_PICK
    .word XT_DOT
    .word XT_DOLOOP,PFA_DOTS1
PFA_DOTS2:
    .word XT_EXIT
