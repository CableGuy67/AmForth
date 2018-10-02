
NONAME IMMEDIATEQ
    .word  XT_DOLITERAL
    .word  Flag_immediate
    .word  XT_AND
    .word  XT_NOTZEROEQUAL
    .word  XT_DOCONDBRANCH,IMMEDIATEQ1
     .word  XT_DOLITERAL,1
     .word  XT_EXIT
IMMEDIATEQ1:
    .word  XT_TRUE
    .word  XT_EXIT
