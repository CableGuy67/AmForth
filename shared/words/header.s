
COLON Flag_visible, "header", HEADER

    .word XT_OVER,XT_GREATERZERO 
    .word XT_DOCONDBRANCH, PFA_HEADER1
    .word XT_EXECUTE
    .word XT_COMMA
    .word XT_HERE,XT_TO_R
    .word XT_DOLITERAL
    .word Flag_visible
    .word XT_COMMA
    .word XT_SCOMMA
    .word XT_R_FROM
    .word XT_EXIT

PFA_HEADER1:
    .word XT_DOLITERAL
    .word -16
    .word XT_THROW
