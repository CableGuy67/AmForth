;C IC,   char --        append char to Code dict
;   IHERE IC! 1 CHARS IALLOT ;
    ; HEADER(ICCOMMA,2,"C,",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      2,"c,"
        .align 16
XT_CCOMMA: DW      DOCOLON
        DW XT_IHERE,XT_CSTOREI,XT_ONE,XT_IALLOT,XT_EXIT
