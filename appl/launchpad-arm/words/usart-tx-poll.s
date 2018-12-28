.equ RXFE, 0x10 @ Receive  FIFO empty
.equ TXFF, 0x20 @ Transmit FIFO full

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-emit", SERIAL_EMIT
@ -----------------------------------------------------------------------------

SERIAL_EMIT_WAIT: 
     ldr r0, =UARTFR
     ldr r0, [r0]
     ands r0, #TXFF
   bne SERIAL_EMIT_WAIT

   ldr r0, =UARTDR
   str tos, [r0]
   loadtos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-emit?", SERIAL_EMITQ
@ -----------------------------------------------------------------------------
   savetos
   mov tos, #0
   ldr r0, =UARTFR
   ldr r1, [r0]
   ands r1, #TXFF
   bne SERIAL_EMITQ1
     mvn tos, tos
SERIAL_EMITQ1:
NEXT
