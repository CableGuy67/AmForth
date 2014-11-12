;C >R    x --   R: -- x   push to return stack
        CODEHEADER(XT_2TO_R,3,"2>r")
        PUSH TOS
        MOV @PSP+,TOS
        PUSH TOS
        MOV @PSP+,TOS
        NEXT
