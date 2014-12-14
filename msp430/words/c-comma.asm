;C C,   char --        append char to dict
;   HERE C! 1 CHARS ALLOT ;
    ; HEADER(CCOMMA,2,"C,",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      2,"c,"
        .align 16
CCOMMA: DW      DOCOLON
        DW XT_HERE,XT_CSTORE,XT_ONE,ALLOT,XT_EXIT
