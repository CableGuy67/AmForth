
COLON ",", COMMA

    .word XT_HERE
    .word XT_STORE
    .word XT_DOLITERAL,4
    .word XT_ALLOT
    .word XT_EXIT

COLON "c,", CCOMMA
   .word XT_HERE
   .word XT_CSTORE
   .word XT_ONE, XT_ALLOT
   .word XT_EXIT
