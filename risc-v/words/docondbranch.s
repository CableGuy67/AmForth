
CODEWORD Flag_visible, "(?branch)", DOCONDBRANCH
    bne zero,x3,PFA_DOBRANCH
    loadtos
    addi x16,x16,4
    NEXT
