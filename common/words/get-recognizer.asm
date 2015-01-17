; ( -- rec-n .. rec-1 n) 
; Interpreter
; Get the current recognizer list

.if cpu_msp430==1
    HEADER(XT_GET_RECOGNIZER,15,"get-recognizer",DOCOLON)
.endif

.if cpu_avr8==1
VE_GET_RECOGNIZER:
    .dw $ff0f
    .db "get-recognizers",0
    .dw VE_HEAD
    .set VE_HEAD = VE_GET_RECOGNIZER
XT_GET_RECOGNIZER:
    .dw DO_COLON
PFA_GET_RECOGNIZER:
.endif
    .dw XT_DOLITERAL
    .dw CFG_RECOGNIZERLISTLEN
    .dw XT_GET_STACK
    .dw XT_EXIT
