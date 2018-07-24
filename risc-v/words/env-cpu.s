COLON Flag_visible, "cpu", ENV_CPU

.word XT_DOSLITERAL
.byte 2f-1f
1: .ascii "RV32IM"
2: .p2align 2
.word XT_EXIT
