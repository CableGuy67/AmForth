; ( -- addr )
; R( -- )
; place PFA on TOS
;VE_DOCONSTANT:
;    .dw $ff0a
;    .db "(constant)"
;    .dw VE_HEAD
;    .set VE_HEAD = VE_DOCONSTANT
XT_DOCONSTANT:
    .dw PFA_DOCONSTANT
PFA_DOCONSTANT:
    savetos
    movw tosl, wl
    adiw tosl, 1
    rjmp DO_NEXT
