.equ UART0BASE, 0x10013000

.equ UART0_TXDATA    , UART0BASE + 0x00
.equ UART0_RXDATA    , UART0BASE + 0x04
.equ UART0_TXCTRL    , UART0BASE + 0x08
.equ UART0_RXCTRL    , UART0BASE + 0x0C
.equ UART0_IE        , UART0BASE + 0x10
.equ UART0_IP        , UART0BASE + 0x14
.equ UART0_DIV       , UART0BASE + 0x18

CODEWORD "+usart", INIT_USART

  # UART RX/TX are selected IOF_SEL on Reset. Set IOF_EN bits.

  li x10, GPIO_IOF_EN
  li x11, (1<<17)|(1<<16)
  sw x11, 0(x10)

  # Set baud rate

  li x10, UART0_DIV
#  li x11, 139-1  # 16 MHz / 115200 Baud = 138.89
  li x11, 417-1  # 16 MHz / 38400 Baud = 416,67
  sw x11, 0(x10)

  # Enable transmit

  li x10, UART0_TXCTRL
  li x11, 1
  sw x11, 0(x10)

  # Enable receive

  li x10, UART0_RXCTRL
  li x11, 1
  sw x11, 0(x10)

  NEXT

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
