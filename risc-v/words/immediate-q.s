
NONAME IMMEDIATEQ
    .word  XT_DOLITERAL
    .word  0x0010
    .word  XT_AND
    .word  XT_ZEROEQUAL
    .word  XT_DOCONDBRANCH,IMMEDIATEQ1
     .word  XT_DOLITERAL,1
     .word  XT_EXIT
IMMEDIATEQ1:
    .word  XT_TRUE
    .word  XT_EXIT
