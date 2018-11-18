
COLON Flag_visible, "header", HEADER

    .word XT_OVER,XT_GREATERZERO 
    .word XT_DOCONDBRANCH, PFA_HEADER1
    .word XT_FETCH
    .word XT_COMMA
    .word XT_DP,XT_TO_R
    .word XT_DOLITERAL
    .word Flag_invisible
    .word XT_COMMA
    .word XT_SCOMMA
    .word XT_R_FROM
    .word XT_EXIT

PFA_HEADER1:
    .word XT_DOLITERAL
    .word -16
    .word XT_THROW
