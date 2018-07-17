
# -----------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_variable, "serial-lastchar", SERIAL_LASTCHAR # ( -- addr )
  CoreVariable serial_lastchar
# -----------------------------------------------------------------------------
  pushdatos
  li x3, serial_lastchar
  NEXT
  .word -1

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-key", SERIAL_KEY
# -----------------------------------------------------------------------------
  push x1

  li x6, serial_lastchar
  pushdatos
  lw x3, 0(x6)

  li x5, -1
  sw x5, 0(x6)

  NEXT



# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-key?", SERIAL_KEYQ
# -----------------------------------------------------------------------------
  pushdatos

  # Check buffer for waiting character

  li x6, serial_lastchar
  lw x5, 0(x6)
  srai x3, x5, 31 # Sign extend the "receive FIFO empty" bit
  beq x3, zero, 1f 

  # No character waiting in the buffer variable. Check UART for new character:

  li x6, UART0_RXDATA
  lw x5, 0(x6)
  li x6, serial_lastchar
  sw x5, 0(x6)

  srai x3, x5, 31 # Sign extend the "receive FIFO empty" bit

1:xori x3, x3, -1

  NEXT
