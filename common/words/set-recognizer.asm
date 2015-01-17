; ( rec-n .. rec-1 n -- ) 
; Interpreter
; replace the recognizer list

.if cpu_msp430==1
    HEADER(XT_SET_RECOGNIZER,15,"set-recognizer",DOCOLON)
.endif

.if cpu_avr8==1
VE_SET_RECOGNIZER:
    .dw $ff0f
    .db "set-recognizers",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SET_RECOGNIZER
XT_SET_RECOGNIZER:
    .dw DO_COLON
PFA_SET_RECOGNIZER:
.endif
    .dw XT_DOLITERAL
    .dw CFG_RECOGNIZERLISTLEN
    .dw XT_SET_STACK
    .dw XT_EXIT

