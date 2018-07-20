
COLON Flag_visible, "sign", SIGN
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH
    .word PFA_SIGN1
    .word XT_DOLITERAL
    .word 45 # ascii -
    .word XT_HOLD
PFA_SIGN1:
    .word XT_EXIT
