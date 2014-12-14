;Z ,DEST   dest --        append a branch address
;   IHERE - , ;
; This appends the given destination address to the branch instruction. 
; The MSP430 uses relative addressing from the location of the offset cell,
; i.e., to branch to FOO the offset cell at $ contains FOO-$.
        ; HEADER(COMMADEST,5,",DEST",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      5,",dest"
        .align 16
COMMADEST: DW      DOCOLON       
        DW  IHERE,XT_MINUS,XT_COMMA,XT_EXIT
