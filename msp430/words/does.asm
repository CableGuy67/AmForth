;C DOES>    --      change action of latest def'n
;   COMPILE (DOES>)
;   dodoes ,JMP ; IMMEDIATE
; Note that MSP430 uses a JMP, not a CALL, to DODOES.
    IMMED(DOES,5,"does>",DOCOLON)
        DW XT_DOLITERAL,XDOES,XT_COMMA
        DW XT_DOLITERAL,dodoes
	DW XT_COMPILE,4030h,XT_COMMA ; compile a machine jump instruction
	DW XT_EXIT
