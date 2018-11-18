
COLON Flag_visible, "s,", SCOMMA
    .word XT_DUP, XT_CCOMMA
    .word XT_ZERO
    .word XT_QDOCHECK
    .word XT_DOCONDBRANCH, PFA_SCOMMA2
    .word XT_DODO
    .word PFA_SCOMMA2
PFA_SCOMMA1:
    .word XT_DUP
    .word XT_CFETCH
    .word XT_CCOMMA
    .word XT_1PLUS
    .word XT_DOLOOP
    .word PFA_SCOMMA1
PFA_SCOMMA2:
    .word XT_DROP 
    .word XT_EXIT
