;C I,    x --           append cell to Code dict
;   IHERE I! 1 CELLS IALLOT ;
    ; HEADER(ICOMMA,2,"I,",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      2,"i,"
        .align 16
ICOMMA: DW      DOCOLON
        DW IHERE,ISTORE,lit,1,XT_CELLS,IALLOT,XT_EXIT
