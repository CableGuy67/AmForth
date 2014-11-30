; ( nt -- xt|0 ) 
; Tools Ext (2012)
; get the interpretation semantics of the word nt
VE_NAME2INTERPRET:
    .dw $ff0e
    .db "name>interpret"
    .dw VE_HEAD
    .set VE_HEAD = VE_NAME2INTERPRET
XT_NAME2INTERPRET:
    .dw DO_COLON
PFA_NAME2INTERPRET:
    .dw XT_NFA2LFA ; skip to link field
    .dw XT_1PLUS   ; next is the execution token
    .dw XT_EXIT
