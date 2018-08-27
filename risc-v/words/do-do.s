
HEADLESS DODO
    # save loop sys
    addi sp, sp, -8
    sw x8, 4(sp)
    sw x9, 0(sp)
    # save loop limits and leave address on stack
    mv x8,x3
    loadtos
    mv x9,x3
    loadtos
    addi x16,x16,4
NEXT
