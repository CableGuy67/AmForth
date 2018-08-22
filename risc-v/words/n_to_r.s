CODEWORD Flag_visible, "n>r", N_TO_R
    mv x5, x3
    mv x6, x3
N_TO_R_LOOP:
    loadtos
    push x3
    addi x5,x5,-1
    bne x5,zero,N_TO_R_LOOP
    push x6
    loadtos
NEXT
