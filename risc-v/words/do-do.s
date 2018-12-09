
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
    # 0x800000 magic
    li x6, 0x80000000
    add x9, x9, x6
    sub  x8, x8, x9
NEXT
