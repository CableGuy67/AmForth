; ( rec-n .. rec-1 n -- ) 
; Interpreter
; replace the recognizer list
VE_SET_RECOGNIZER:
    .dw $ff0f
    .db "set-recognizers",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SET_RECOGNIZER
XT_SET_RECOGNIZER:
    .dw DO_COLON
PFA_SET_RECOGNIZER:
    .dw XT_DOLITERAL
    .dw EE_RECOGNIZERLISTLEN
    .dw XT_SET_STACK
    .dw XT_EXIT

