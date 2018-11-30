
NONAME IMMEDIATEQ
    .word XT_FETCH
    .word  XT_DOLITERAL
    .word  Flag_immediate
    .word  XT_TUCK
    .word  XT_AND
    .word  XT_EQUAL
    .word  XT_DOCONDBRANCH,IMMEDIATEQ1
     .word  XT_ONE
     .word  XT_EXIT
IMMEDIATEQ1:
    .word  XT_MINUSONE
    .word  XT_EXIT
