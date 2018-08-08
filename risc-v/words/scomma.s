
COLON Flag_visible, "s,", SCOMMA
    .word XT_DUP
    .word XT_DOSCOMMA
    .word XT_EXIT

NONAME DOSCOMMA
    .word XT_COMMA
    .word XT_DUP 
    .word XT_2SLASH
    .word XT_TUCK  
    .word XT_2STAR 
    .word XT_MINUS 
    .word XT_TO_R
    .word XT_ZERO
    .word XT_QDOCHECK
    .word XT_DOCONDBRANCH, PFA_SCOMMA2
    .word XT_DODO
    .word PFA_SCOMMA2
PFA_SCOMMA1:
    .word XT_DUP
    .word XT_FETCH
    .word XT_COMMA
    .word XT_CELLPLUS
    .word XT_DOLOOP
    .word PFA_SCOMMA1
PFA_SCOMMA2:
    .word XT_R_FROM
    .word XT_GREATERZERO
    .word XT_DOCONDBRANCH, PFA_SCOMMA3
      .word XT_DUP
      .word XT_CFETCH
      .word XT_COMMA
PFA_SCOMMA3:
    .word XT_DROP 
    .word XT_EXIT
