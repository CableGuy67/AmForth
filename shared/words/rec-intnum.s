
DATA "rectype-num", RECTYPE_NUM
    .word XT_NOOP    
    .word XT_LITERAL 
    .word XT_LITERAL 

DATA "rectype-dnum", RECTYPE_DNUM
    .word XT_NOOP 
    .word XT_2LITERAL
    .word XT_2LITERAL

COLON Flag_visible, "rec-num", REC_NUM
    .word XT_NUMBER
    .word XT_DOCONDBRANCH,PFA_REC_NONUMBER
    .word XT_DOLITERAL,1
    .word XT_EQUAL
    .word XT_DOCONDBRANCH, PFA_REC_INTNUM2
      .word XT_RECTYPE_NUM
      .word XT_EXIT
PFA_REC_INTNUM2:
      .word XT_RECTYPE_DNUM
      .word XT_EXIT
PFA_REC_NONUMBER:
    .word XT_RECTYPE_NULL
    .word XT_EXIT
