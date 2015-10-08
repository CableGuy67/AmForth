;X KEY?     -- f    return true if char waiting
        CODEHEADER(XT_USART_RXQ,3,"rx?")
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        bit.b   #UCRXIFG, &UCA1IFG
        JNZ     TOSTRUE
        JMP     TOSFALSE

