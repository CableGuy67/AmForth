; ----------------------------------------------------------------------
; TERMINAL I/O (TARGET-SPECIFIC)

;C EMIT?     c --    output character to console
        CODEHEADER(XT_USART_TXQ,3,"tx?")
        bit.b   #UCTXIFG, &UCA1IFG
        JNZ     TOSTRUE
        JMP     TOSFALSE
