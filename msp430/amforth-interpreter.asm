DOCOLON: 
        PUSH IP         ; 3 save old IP on return stack
        MOV W,IP        ; 1 set new IP to PFA
DO_NEXT:
	TST R15
        JNZ DO_INT
DO_REALLY_NEXT:
        MOV @IP+,W      ; fetch word address into W
        MOV @W+,PC      ; fetch code address into PC, W=PFA
DO_INT:
	CLR R15
	JMP DO_REALLY_NEXT
