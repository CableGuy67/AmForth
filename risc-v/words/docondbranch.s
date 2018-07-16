
CODEWORD Flag_visible, "(?branch)", DO_COND_BRANCH
    bne zero,x16,PFA_DO_BRANCH
    loadtos
    NEXT
