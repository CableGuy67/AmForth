; ( -- addr) 
; Stack
; start address of the data stack
VE_SP0:
    .dw $ff03
    .db "sp0",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SP0
XT_SP0:
    .dw PFA_DOVALUE1
PFA_SP0:
    .dw USER_SP0
    .dw XT_UDEFERFETCH
    .dw XT_UDEFERSTORE
