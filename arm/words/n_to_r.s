CODEWORD "n>r", N_TO_R
    mov r0, tos
    mov r1, tos
N_TO_R_LOOP:
    loadtos
    push {tos}
    subs r0,1
    bne N_TO_R_LOOP
    push {r1}
    loadtos
NEXT
