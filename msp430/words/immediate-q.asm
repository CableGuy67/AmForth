; ( -- d ) 
; System
; put the cpu frequency in Hz on stack
.if cpu_msp430==1
    HEADLESS(XT_IMMEDIATEQ,DOCOLON)
    .dw XT_DOLITERAL
    .dw 1
    .dw XT_AND
    .dw XT_ZEROEQUAL
.endif

.if cpu_avr8==1
;VE_IMMEDIATEQ:
;    .dw $ff05
;    .db "f_cpu",0
;    .dw VE_HEAD
;    .set VE_HEAD = VE_F_CPU
XT_IMMEDIATEQ:
    .dw DO_COLON
.endif
    .dw XT_EXIT
