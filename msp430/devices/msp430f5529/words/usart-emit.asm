; ----------------------------------------------------------------------
; TERMINAL I/O (TARGET-SPECIFIC)

;C EMIT     c --    output character to console
        CODEHEADER(XT_USART_TX,2,"tx")
EMITLOOP:
        bit.b   #UCTXIFG, &UCA1IFG
        JZ      EMITLOOP
        MOV.B   TOS,&UCA1TXBUF
        MOV @PSP+,TOS
        NEXT
