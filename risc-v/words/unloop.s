
CODEWORD Flag_visible, "unloop", UNLOOP
    # restore loop-sys
    lw x9, 0(sp)
    lw x8, 4(sp)
    addi sp, sp, 8
    NEXT
