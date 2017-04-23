        CODEHEADER(XT_TRAP,8,"int-trap")
        MOV TOS,R15
        MOV @PSP+,TOS
        NEXT
