
.set USART_TX_DATA=UCA0TXBUF
.set USART_RX_DATA=UCA0RXBUF
.set USART_TX_CFG=UCA0TXIFG
.set USART_RX_CFG=UCA0RXIFG

.include "drivers/usart_common.inc"

.include "words/usart-tx.asm"
.include "words/usart-emitq.asm"
.include "words/usart-rx.asm"
.include "words/usart-keyq.asm"
.include "words/usart-init.asm"
