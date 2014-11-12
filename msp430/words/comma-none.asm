;Z ,NONE   --              append a null destination (Flashable)
;   CELL IALLOT ;
; When compiling in Flash ROM a branch to be resolved later, we must
; skip the cell so that it can be programmed at a later time.
; In general Flash memory can only be written once!
; ,NONE should be used wherever !DEST will resolve the branch.
        ; HEADER(COMMANONE,5,",NONE",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      5,",none"
        .align 16
COMMANONE: DW      DOCOLON        
        DW  CELL,IALLOT,XT_EXIT
