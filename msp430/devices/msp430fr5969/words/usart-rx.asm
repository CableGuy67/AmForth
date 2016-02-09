;C KEY      -- c      get character from keyboard
        HEADER(XT_USART_RX_POLL,2,"rx",DOCOLON)
KEYLOOP:
	.dw XT_PAUSE
	.DW XT_KEYQ
	.dw XT_DOCONDBRANCH
	DEST(KEYLOOP)
	.dw XT_DOLITERAL
	.dw UCA0RXBUF
	.dw XT_CFETCH
	.dw XT_EXIT
