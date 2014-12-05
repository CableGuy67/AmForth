; ( recn .. rec0 n ee-addr -- ) 
; Tools
; Write a stack to EEPROM
VE_SET_STACK:
    .dw $ff09
    .db "set-stack",0
    .dw VE_HEAD
    .set VE_HEAD = VE_SET_STACK
XT_SET_STACK:
    .dw DO_COLON
PFA_SET_STACK:
    .dw XT_2DUP
    .dw XT_STOREE ; ( -- i_n .. i_0 n e-addr )
    .dw XT_SWAP    
    .dw XT_ZERO
    .dw XT_QDOCHECK
    .dw XT_DOCONDBRANCH
    .dw PFA_SET_STACK2
    .dw XT_DODO
PFA_SET_STACK1:
    .dw XT_CELLPLUS ; ( -- i_x e-addr )
    .dw XT_TUCK      ; ( -- e-addr i_x e-addr
    .dw XT_STOREE
    .dw XT_DOLOOP
    .dw PFA_SET_STACK1
PFA_SET_STACK2:
    .dw XT_DROP
    .dw XT_EXIT

