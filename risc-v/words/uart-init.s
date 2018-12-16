
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
