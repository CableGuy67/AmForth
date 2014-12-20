;Z ,JMP   adrs --       append an absolute 16-bit JMP  (MOV #xx,PC)
; MSP430:  opcode 4, Sreg=0000, Ad=0, As=11 (immed), Dreg=0000 (PC)  
; thus append 4030,adrs.
	HEADLESS(XT_COMMAJMP, DOCOLON)
        DW XT_DOLITERAL,4030h,XT_COMMA,XT_COMMA,XT_EXIT
