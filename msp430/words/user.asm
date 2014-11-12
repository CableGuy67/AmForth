;Z USER     n --        define user variable 'n'
;   <BUILDS I, DOES> (machine code fragment)    Flashable model
        HEADER(USER,4,"user",DOCOLON)
        DW BUILDS,ICOMMA,XDOES
DOUSER: ; -- a-addr     ; add constant to User Pointer, result in TOS
        SUB #2,PSP
        MOV TOS,0(PSP)
        MOV @W,TOS
        ADD &UP,TOS
        NEXT
