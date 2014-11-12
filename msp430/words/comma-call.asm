;Z ,CALL  adrs --       append a subroutine CALL
; MSP430:  128x is call, Ad=11, Dreg=0000 (PC)  thus append 12B0,adrs.
        ; HEADER(COMMACALL,5,",CALL",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      5,",call"
        .align 16
COMMACALL: DW      DOCOLON        
        DW lit,12B0h,ICOMMA,ICOMMA,XT_EXIT
