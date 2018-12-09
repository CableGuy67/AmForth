
VALUE "lp0", LP0, RAM_upper_leavestack
VARIABLE "lp", LP

COLON Flag_visible, "l>", L_FROM
    .word XT_LP
    .word XT_FETCH
    .word XT_FETCH
    .word XT_DOLITERAL
    .word 4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_EXIT

COLON Flag_visible, ">l", TO_L

    .word XT_DOLITERAL,-4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_LP
    .word XT_FETCH
    .word XT_STORE
    .word XT_EXIT

IMMED "leave", LEAVE
    .word XT_COMPILE,XT_UNLOOP
    .word XT_AHEAD,XT_TO_L,XT_EXIT
