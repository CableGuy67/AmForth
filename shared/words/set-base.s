
DATA "bases", BASES
    .word 10,16,2,10 

COLON Flag_visible, "set-base", SET_BASE
    .word XT_OVER
    .word XT_CFETCH
    .word XT_DOLITERAL
    .word 35
    .word XT_MINUS
    .word XT_DUP
    .word XT_ZERO
    .word XT_DOLITERAL
    .word 4
    .word XT_WITHIN
    .word XT_DOCONDBRANCH,SET_BASE1
        .word XT_CELLS
	.word XT_BASES
	.word XT_PLUS
	.word XT_FETCH
	.word XT_BASE
	.word XT_STORE
	.word XT_DOLITERAL,1
	.word XT_SLASHSTRING
	.word XT_DOBRANCH,SET_BASE2
SET_BASE1:
	.word XT_DROP
SET_BASE2:
    .word XT_EXIT 
