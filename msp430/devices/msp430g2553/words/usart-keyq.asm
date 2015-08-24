;X KEY?     -- f    return true if char waiting
        CODEHEADER(XT_USART_RXQ,3,"tx?")
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        BIT.B   #UCA0RXIFG,&IFG2
        JNZ     TOSTRUE
        JMP     TOSFALSE

