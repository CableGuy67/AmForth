
COLON Flag_visible, "accept", ACCEPT

        .word XT_OVER,XT_PLUS,XT_OVER
ACC1:   .word XT_KEY,XT_DUP,XT_CRLFQ,XT_ZEROEQUAL,XT_DOCONDBRANCH
        .word ACC5
        .word XT_DUP,XT_DOLITERAL,8,XT_EQUAL,XT_DOCONDBRANCH
        .word ACC3
        .word XT_DROP,XT_ROT,XT_2DUP,XT_GREATER,XT_TO_R,XT_ROT,XT_ROT,XT_R_FROM,XT_DOCONDBRANCH
	.word ACC6
	.word XT_BS,XT_1MINUS,XT_TO_R,XT_OVER,XT_R_FROM,XT_UMAX
ACC6:   .word XT_DOBRANCH
        .word ACC4
ACC3:    
	.word XT_DUP,XT_BL,XT_LESS,XT_DOCONDBRANCH
        .word PFA_ACCEPT6
          .word XT_DROP
          .word XT_BL
PFA_ACCEPT6:
	.word XT_TO_R,XT_2DUP,XT_GREATER,XT_R_FROM,XT_SWAP,XT_DOCONDBRANCH
        .word ACC7
            .word XT_DUP,XT_EMIT,XT_OVER,XT_CSTORE,XT_1PLUS,XT_OVER,XT_UMIN
	    .word XT_DOBRANCH
	    .word ACC4 
ACC7:   .word XT_DROP
ACC4:   .word XT_DOBRANCH
        .word ACC1
ACC5:   .word XT_DROP,XT_NIP,XT_SWAP,XT_MINUS,XT_EXIT


COLON Flag_visible, "bs", BS
    .word XT_DOLITERAL
    .word 8
    .word XT_DUP
    .word XT_EMIT
    .word XT_SPACE
    .word XT_EMIT
    .word XT_EXIT

COLON Flag_visible, "?crlf", CRLFQ

    .word XT_DUP
    .word XT_DOLITERAL
    .word 13
    .word XT_EQUAL
    .word XT_SWAP
    .word XT_DOLITERAL
    .word 10
    .word XT_EQUAL
    .word XT_OR
    .word XT_EXIT
