
# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-emit", SERIAL_EMIT
# -----------------------------------------------------------------------------

  li x6, UART0_TXDATA
  sw x3, 0(x6)
  loadtos

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-emit?", SERIAL_EMITQ
# -----------------------------------------------------------------------------
  pushdatos
  li x5, UART0_TXDATA
  lw x5, 0(x5)
  srai x5, x5, 31  # Sign extend the "transmit FIFO full" bit
  xori x3, x5, -1  # Invert it

  NEXT
