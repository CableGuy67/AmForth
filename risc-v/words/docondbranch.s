
CODEWORD Flag_visible, "(?branch)", DOCONDBRANCH
    addi x5,x3,0
    loadtos
    bne zero,x5,PFA_DOBRANCH
    addi x16,x16,4
    NEXT
