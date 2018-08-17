

COLON Flag_visible, "A-V", FORALL
    .word XT_DP
    .word XT_DOLITERAL
    .word XT_CHECKVAR
    .word XT_SWAP
    .word XT_TRAVERSEWORDLIST
    .word XT_EXIT

NONAME CHECKVAR
    .word XT_DUP
    .word XT_NAME2FLAGS, XT_FETCH,XT_DOLITERAL, Flag_defer, XT_DUP,XT_ROT,XT_AND,XT_EQUAL
    .word XT_DOCONDBRANCH,PFA_CHECKVAR1
	.word XT_NAME2STRING
        .word XT_TYPE
	.word XT_SPACE
	.word XT_TRUE
	.word XT_EXIT
PFA_CHECKVAR1:
    .word XT_DROP
    .word XT_TRUE
    .word XT_EXIT
