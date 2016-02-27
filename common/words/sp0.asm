; ( -- c ) 
; Stack
; get the initial stack pointer address

.if cpu_msp430==1
    HEADER(XT_SP0,3,"sp0",DOVALUE)
.endif

.if cpu_avr8==1
VE_SP0:
    .dw $ff03
    .db "sp0",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SP0
XT_SP0:
    .dw PFA_DOVALUE1
PFA_SP0:
.endif
    .dw USER_SP0
    .dw XT_UDEFERFETCH
    .dw XT_UDEFERSTORE
