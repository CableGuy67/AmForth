
COLON Flag_visible, "?do", QDO
#    .dw XT_COMPILE
#    .dw XT_QDOCHECK
#    .dw XT_IF
#    .dw XT_DO
#    .dw XT_SWAP    ; DO sets a 0 marker on the leave stack
#    .dw XT_TO_L    ; then follows at the end.
#    .dw XT_EXIT


HEADLESS QDOCHECK
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
