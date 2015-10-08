;C KEY      -- c      get character from keyboard
        CODEHEADER(XT_USART_RX,2,"rx")
KEYLOOP:
        bit.b   #UCRXIFG, &UCA1IFG
        JZ      KEYLOOP
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        MOV.B   &UCA1RXBUF,TOS
donext: NEXT
