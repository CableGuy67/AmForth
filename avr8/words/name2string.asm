; ( nt -- addr len ) 
; Tools Ext (2012)
; get a (flash) string from a name token nt
VE_NAME2STRING:
    .dw $ff0b
    .db "name>string",0
    .dw VE_HEAD
    .set VE_HEAD = VE_NAME2STRING
XT_NAME2STRING:
    .dw DO_COLON
PFA_NAME2STRING:
    .dw XT_ICOUNT   ; ( -- addr n )
    .dw XT_DOLITERAL
    .dw $00FF
    .dw XT_AND      ; mask immediate bit
    .dw XT_EXIT
