
  VARIABLE  "serial-lastchar", SERIAL_LASTCHAR # ( -- addr )

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key", SERIAL_KEY
# -----------------------------------------------------------------------------
  savetos
  la x6, PFA_SERIAL_LASTCHAR
  lw x6, 0(x6)
  lw x3, 0(x6)

  li x5, -1
  sw x5, 0(x6)

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key?", SERIAL_KEYQ
# -----------------------------------------------------------------------------

  savetos

  # Check buffer for waiting character

  la x6, PFA_SERIAL_LASTCHAR
  lw x5, 0(x6)
  srai x3, x5, 31 # Sign extend the "receive FIFO empty" bit
  beq x3, zero, 1f 

  # No character waiting in the buffer variable. Check UART for new character:

  li x6, UART0_RXDATA
  lw x5, 0(x6)
  la x6, PFA_SERIAL_LASTCHAR
  lw x6, 0(x6)
  sw x5, 0(x6)

  srai x3, x5, 31 # Sign extend the "receive FIFO empty" bit

1:
  xori x3, x3, -1
  NEXT
