; ( -- c ) 
; Stack
; get the last saved retuern stack pointer address

.if cpu_msp430==1
    HEADER(XT_RP0,3,"rp0",DOVALUE)
.endif

.if cpu_avr8==1
VE_RP0:
    .dw $ff03
    .db "rp0",0
    .dw VE_HEAD
    .set VE_HEAD = VE_RP0
XT_RP0:
    .dw PFA_DOVALUE1
PFA_RP0:
.endif
    .dw USER_RP
    .dw XT_UDEFERFETCH
    .dw XT_UDEFERSTORE
