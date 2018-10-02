HEADLESS DOCONDBRANCH
    mov r0, tos
    loadtos
    cmp r0, #0
    beq PFA_DOBRANCH
    adds FORTHIP, #4
NEXT
