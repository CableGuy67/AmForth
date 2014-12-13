; compiles a string to the dictionary. Does not add a runtime action.
        DW      link
        DB      0FEh       ; immediate
.set link = $
        DB      3,"s",','
        .align 16
XT_SCOMMA: 
	DW      DOCOLON
        DW XT_DUP,XT_TO_R,ICCOMMA,IHERE,XT_R_FETCH,DTOI
        DW XT_R_FROM,IALLOT,ALIGNN,XT_EXIT
