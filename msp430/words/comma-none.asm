;Z ,NONE   --              append a null destination (Flashable)
;   CELL IALLOT ;
; When compiling in Flash ROM a branch to be resolved later, we must
; skip the cell so that it can be programmed at a later time.
; In general Flash memory can only be written once!
; ,NONE should be used wherever !DEST will resolve the branch.
	HEADLESS(XT_COMMANONE,DOCOLON)
        DW  XT_TWO,XT_IALLOT,XT_EXIT
