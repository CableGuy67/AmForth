;C I,    x --           append cell to Code dict
;   IHERE I! 1 CELLS IALLOT ;
    ; HEADER(COMMA,2,",",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      1,","
        .align 16
XT_COMMA: DW      DOCOLON
        DW IHERE,ISTORE,XT_ONE,XT_CELLS,IALLOT,XT_EXIT
