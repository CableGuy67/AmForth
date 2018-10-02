
IMMED "?do", QDO
    .word XT_COMPILE
    .word XT_QDOCHECK
    .word XT_IF
    .word XT_DO
    .word XT_EXIT

NONAME QDOCHECK
    .word XT_2DUP
    .word XT_EQUAL
    .word XT_DUP
    .word XT_DOCONDBRANCH, PFA_QDOCHECK1
    .word XT_NIP,XT_NIP
PFA_QDOCHECK1:
    .word XT_INVERT
    .word XT_EXIT
