
COLON Flag_visible, "<#", L_SHARP

    .word XT_PAD, XT_HLD, XT_STORE
    .word XT_EXIT

COLON Flag_visible, "#", SHARP

    .word XT_BASE, XT_FETCH
    .word XT_UDSLASHMOD, XT_ROT
    .word XT_DOLITERAL, 9
    .word XT_OVER, XT_LESS
    .word XT_DOCONDBRANCH, PFA_SHARP1
    .word XT_DOLITERAL, 7, XT_PLUS
PFA_SHARP1:
    .word XT_DOLITERAL, 48, XT_PLUS
    .word XT_HOLD, XT_EXIT

COLON Flag_visible, "#s", SHARP_S
    .word XT_SHARP, XT_2DUP, XT_OR
    .word XT_ZEROEQUAL, XT_DOCONDBRANCH, PFA_SHARP_S
    .word XT_EXIT

COLON Flag_visible, "#>", SHARP_GREATER
    .word XT_2DROP, XT_HLD, XT_FETCH
    .word XT_PAD, XT_OVER, XT_MINUS
    .word XT_EXIT
