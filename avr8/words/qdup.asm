; ( n1 -- [ n1 n1 ] | 0) 
; Stack
; duplicate TOS if non-zero
VE_QDUP:
    .dw $ff04
    .db "?dup"
    .dw VE_HEAD
    .set VE_HEAD = VE_QDUP
XT_QDUP:
    .dw PFA_QDUP
PFA_QDUP:
    or tosl, tosh
    breq PFA_QDUP1
    savetos
PFA_QDUP1:
    jmp_ DO_NEXT
