
IMMED "?do", QDO
    .word XT_COMPILE
    .word XT_QDOCHECK
    .word XT_IF
    .word XT_DO
    .word XT_SWAP
    .word XT_TO_L
    .word XT_EXIT

NONAME QDOCHECK
    .word XT_2DUP
    .word XT_EQUAL
    .word XT_DUP
    .word XT_TO_R
    .word XT_DOCONDBRANCH, PFA_QDOCHECK1
    .word XT_2DROP
PFA_QDOCHECK1:
    .word XT_R_FROM
    .word XT_INVERT
    .word XT_EXIT

