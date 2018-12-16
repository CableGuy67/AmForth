CODEWORD "nr>", N_R_FROM
    pop x5
    mv x6, x5
    savetos
N_R_FROM_LOOP:
    pop x3
    savetos
    addi x5,x5,-1
    bne x5,zero,N_R_FROM_LOOP
    mv x3, x6
NEXT
