
.set USART_TX_DATA=UCA1TXBUF
.set USART_RX_DATA=UCA1RXBUF
.set USART_TX_CFG=UCA1IFG
.set USART_RX_CFG=UCA1IFG

.include "drivers/usart_common.inc"

.include "words/usart-tx.asm"
.include "words/usart-emitq.asm"
.include "words/usart-rx.asm"
.include "words/usart-keyq.asm"
.include "words/usart-init.asm"
