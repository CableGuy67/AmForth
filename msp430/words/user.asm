;Z USER     n --        define user variable 'n'
;   <BUILDS I, DOES> (machine code fragment)    Flashable model
        HEADER(XT_USER,4,"user",DOCOLON)
        DW XT_BUILDS,XT_COMMA,XDOES
DOUSER: ; -- a-addr     ; add constant to User Pointer, result in TOS
        SUB #2,PSP
        MOV TOS,0(PSP)
        MOV @W,TOS
        ADD &UP,TOS
        NEXT

CODEHEADER(XT_UP_FETCH,3,"up@")
        SUB    #2,PSP
        MOV &UP,TOS
	NEXT