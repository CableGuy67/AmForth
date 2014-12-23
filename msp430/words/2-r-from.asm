;C 2R>    -- d    R: d --   pop from return stack
        CODEHEADER(XT_2R_FROM,3,"2r>")
        SUB #4,PSP      ; 2
        MOV TOS,2(PSP)    ; 4
        MOV @RSP+,TOS
        MOV TOS,0(PSP)    ; 4
        MOV @RSP+,TOS
        MOV     @PSP,W          ; 2
        MOV     TOS,0(PSP)      ; 4
        MOV     W,TOS           ; 1

        NEXT
