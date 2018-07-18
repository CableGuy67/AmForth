COLON Flag_visible, "cpu", ENV_CPU

.word XT_DOSLITERAL
.word 2f-1f
1: .ascii "RISC-V 32 IM"
2: .p2align 2
.word XT_EXIT
