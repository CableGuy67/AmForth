;C IC,   char --        append char to Code dict
;   IHERE IC! 1 CHARS IALLOT ;
    ; HEADER(ICCOMMA,3,"IC,",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      3,"ic,"
        .align 16
ICCOMMA: DW      DOCOLON
        DW IHERE,ICSTORE,XT_ONE,IALLOT,XT_EXIT
