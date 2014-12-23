;C 2>R    d --   R: -- d   push to return stack
        CODEHEADER(XT_2TO_R,3,"2>r")
        MOV     @PSP,W          ; 2
        MOV     TOS,0(PSP)      ; 4
        MOV     W,TOS           ; 1
        PUSH TOS
        MOV @PSP+,TOS
        PUSH TOS
        MOV @PSP+,TOS
        NEXT
