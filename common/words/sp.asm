; ( -- a-addr ) 
; Numeric IO
; location of the cell containing the number conversion radix

.if cpu_msp430==1
    HEADER(XT_SP,2,"sp",DOUSER)
.endif

.if cpu_avr8==1
VE_SP:
    .dw $ff02
    .db "sp"
    .dw VE_HEAD
    .set VE_HEAD = VE_SP
XT_SP:
    .dw PFA_DOUSER
PFA_SP:
.endif
    .dw USER_SP
