; ( d1 -- d2 ) 
; Arithmetics
; double cell negation

.if cpu_msp430==1
    HEADER(XT_DNEGATE,7,"dnegate",DOCOLON)
.endif

.if cpu_avr8==1
VE_DNEGATE:
    .dw $ff07
    .db "dnegate",0
    .dw VE_HEAD
    .set VE_HEAD = VE_DNEGATE
XT_DNEGATE:
    .dw DO_COLON
PFA_DNEGATE:
.endif
;    .dw XT_DINVERT
    .dw XT_SWAP,XT_INVERT,XT_SWAP,XT_INVERT
    .dw XT_ONE
    .dw XT_MPLUS
    .dw XT_EXIT
