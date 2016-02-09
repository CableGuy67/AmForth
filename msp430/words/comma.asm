;C I,    x --           append cell to Code dict
;   IHERE I! 1 CELLS IALLOT ;
    ; HEADER(COMMA,1,",",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      1,","
        .align 16
XT_COMMA: DW      DOCOLON
        DW XT_IHERE,XT_STOREI,XT_TWO,XT_IALLOT,XT_EXIT
