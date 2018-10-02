CODEWORD Flag_visible, "nr>", N_R_FROM
    pop {r1}
    mov r0, r1
    savetos
N_R_FROM_LOOP:
    pop {tos}
    savetos
    subs r0,1
    bne N_R_FROM_LOOP
    mov tos, r1
NEXT
