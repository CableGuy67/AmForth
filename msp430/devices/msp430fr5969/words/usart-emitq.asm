; ----------------------------------------------------------------------
; TERMINAL I/O (TARGET-SPECIFIC)

;C EMIT     c --    output character to console
        CODEHEADER(XT_USART_TXQ,3,"tx?")
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        bit.b   #UCTXIFG, &UCA0IFG
        JNZ     TOSTRUE
        JMP     TOSFALSE
