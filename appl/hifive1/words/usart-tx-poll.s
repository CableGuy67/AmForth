
# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit", SERIAL_EMIT
# -----------------------------------------------------------------------------

SERIAL_EMIT_WAIT:
  li x5, UART0_TXDATA
  lw x5, 0(x5)
  blt x5,zero, SERIAL_EMIT_WAIT

  li x6, UART0_TXDATA
  sw x3, 0(x6)
  loadtos

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit?", SERIAL_EMITQ
# -----------------------------------------------------------------------------
  savetos
  li x5, UART0_TXDATA
  lw x5, 0(x5)
  srai x5, x5, 31  # Sign extend the "transmit FIFO full" bit
  xori x3, x5, -1  # Invert it

  NEXT
