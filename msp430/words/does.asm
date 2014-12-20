;C DOES>    --      change action of latest def'n
;   COMPILE (DOES>)
;   dodoes ,JMP ; IMMEDIATE
; Note that MSP430 uses a JMP, not a CALL, to DODOES.
    IMMED(DOES,5,"does>",DOCOLON)
        DW XT_DOLITERAL,XDOES,XT_COMMA
        DW XT_DOLITERAL,dodoes,XT_COMMAJMP,XT_EXIT
