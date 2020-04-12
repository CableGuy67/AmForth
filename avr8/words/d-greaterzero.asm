; ( d -- flag )
; Compare
; compares if a double double cell number is greater 0
VE_DGREATERZERO:
    .dw $ff03
    .db "d0>",0
    .dw VE_HEAD
    .set VE_HEAD = VE_DGREATERZERO
XT_DGREATERZERO:
    .dw PFA_DGREATERZERO
PFA_DGREATERZERO:
    cp tosh, zeroh
    brlt PFA_DGREATERZERO_FALSE ; if MSBit is set, d:arg is negative, we are done (false).
    cpc tosl, zerol
    loadtos
    cpc tosl, zerol
    cpc tosh, zeroh
    brbs 1, PFA_ZERO1           ; if all 4 Bytes of d:arg are zero, we are done (false).
    rjmp PFA_TRUE1              ; if we get this far, d:arg was positive! (true)
PFA_DGREATERZERO_FALSE:
    movw tosl, zerol            ; ZERO
    rjmp PFA_NIP                ; NIP
