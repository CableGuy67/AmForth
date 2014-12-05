; ( -- ) 
; Tools
; stack dump
VE_DOTS:
    .dw $ff02
    .db ".s"
    .dw VE_HEAD
    .set VE_HEAD = VE_DOTS
XT_DOTS:
    .dw DO_COLON
PFA_DOTS:
    .dw XT_DEPTH
    .dw XT_UDOT
    .dw XT_SPACE
    .dw XT_DEPTH
    .dw XT_ZERO
    .dw XT_QDOCHECK
    .dw XT_DOCONDBRANCH
    .dw PFA_DOTS2
    .dw XT_DODO
PFA_DOTS1:
    .dw XT_I
    .dw XT_PICK
    .dw XT_UDOT
    .dw XT_DOLOOP
    .dw PFA_DOTS1
PFA_DOTS2:
    .dw XT_EXIT
