COLON "number", NUMBER

    .word XT_BASE
    .word XT_FETCH
    .word XT_TO_R
    .word XT_QSIGN
    .word XT_TO_R
    .word XT_SET_BASE
    .word XT_QSIGN
    .word XT_R_FROM
    .word XT_OR
    .word XT_TO_R

    .word XT_DUP
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH,PFA_NUMBER0
      .word XT_2DROP
      .word XT_R_FROM
      .word XT_DROP
      .word XT_R_FROM
      .word XT_BASE
      .word XT_STORE
      .word XT_ZERO
      .word XT_EXIT
PFA_NUMBER0:
    .word XT_2TO_R
    .word XT_ZERO       
    .word XT_ZERO
    .word XT_2R_FROM
    .word XT_TO_NUMBER 
    .word XT_QDUP
    .word XT_DOCONDBRANCH, PFA_NUMBER1
      .word XT_DOLITERAL,1
      .word XT_EQUAL
      .word XT_DOCONDBRANCH,PFA_NUMBER2
	.word XT_CFETCH
	.word XT_DOLITERAL, 0x2e 
	.word XT_EQUAL
	.word XT_DOCONDBRANCH, PFA_NUMBER6
	.word XT_R_FROM
        .word XT_DOCONDBRANCH, PFA_NUMBER3
        .word XT_DNEGATE
PFA_NUMBER3:
	.word XT_DOLITERAL,2
	.word XT_DOBRANCH, PFA_NUMBER5
PFA_NUMBER2:
	.word XT_DROP
PFA_NUMBER6:
	.word XT_2DROP
	.word XT_R_FROM
	.word XT_DROP
        .word XT_R_FROM
        .word XT_BASE
        .word XT_STORE
	.word XT_ZERO
	.word XT_EXIT
PFA_NUMBER1:
    .word XT_2DROP 
    .word XT_R_FROM
    .word XT_DOCONDBRANCH, PFA_NUMBER4
    .word XT_NEGATE
PFA_NUMBER4:
    .word XT_DOLITERAL, 1
PFA_NUMBER5:
    .word XT_R_FROM
    .word XT_BASE
    .word XT_STORE
    .word XT_TRUE
    .word XT_EXIT
