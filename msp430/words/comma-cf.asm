;Z ,CF    adrs --       append a code field
;   IHERE !CF 2 IALLOT ;  MSP430 VERSION (2 bytes)
        ; HEADER(COMMACF,3,",CF",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      3,",cf"
        .align 16
XT_COMMACF: DW      DOCOLON        
        DW IHERE,XT_STORECF,XT_TWO,IALLOT,XT_EXIT
