
COLON "recognize", RECOGNIZE

    .word XT_DOLITERAL
    .word XT_RECOGNIZE_A
    .word XT_SWAP
    .word XT_MAPSTACK
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH, PFA_RECOGNIZE1
      .word XT_2DROP
      .word XT_RECTYPE_NULL
PFA_RECOGNIZE1:
    .word XT_EXIT

NONAME RECOGNIZE_A
   .word XT_ROT
   .word XT_ROT
   .word XT_2DUP 
   .word XT_2TO_R
   .word XT_ROT
   .word XT_EXECUTE
   .word XT_2R_FROM
   .word XT_ROT
   .word XT_DUP
   .word XT_RECTYPE_NULL
   .word XT_EQUAL
   .word XT_DOCONDBRANCH,PFA_RECOGNIZE_A1
     .word XT_DROP
     .word XT_ZERO
     .word XT_EXIT
PFA_RECOGNIZE_A1:
   .word XT_NIP 
   .word XT_NIP
   .word XT_TRUE
   .word XT_EXIT
