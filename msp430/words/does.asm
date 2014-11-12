;C DOES>    --      change action of latest def'n
;   COMPILE (DOES>)
;   dodoes ,JMP ; IMMEDIATE
; Note that MSP430 uses a JMP, not a CALL, to DODOES.
    IMMED(DOES,5,"does>",DOCOLON)
        DW lit,XDOES,COMMAXT
        DW lit,dodoes,COMMAJMP,XT_EXIT
