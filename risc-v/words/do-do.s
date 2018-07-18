

CODEWORD Flag_visible,"(do)", DODO
    # save loop sys
    addi sp, sp, -12
    sw x8, 8(sp)
    sw x9, 4(sp)
    sw x10, 0(sp)
    # save loop limits and leave address on stack
    mv x8,x3
    loadtos
    mv x9,x3
    loadtos
    lw x10, 0(x16)
    addi x16,x16,4
NEXT
