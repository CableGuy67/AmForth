DOCOLON: 
        PUSH IP         ; 3 save old IP on return stack
        MOV W,IP        ; 1 set new IP to PFA

.if WANT_INTERRUPTS==1
DO_NEXT:
	TST ISR
        JNZ DO_INT
DO_REALLY_NEXT:
        MOV @IP+,W      ; fetch word address into W
        MOV @W+,PC      ; fetch code address into PC, W=PFA
DO_INT:
	CLR ISR
	JMP DO_REALLY_NEXT
.else
	NEXT
.endif
