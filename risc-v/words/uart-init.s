
CODEWORD Flag_visible, "+usart", INIT_USART

  # Wait for crystal to oscillate:

1:li x10, PRCI_HFXOSCCFG   # 0x10008004
  lw x11, 0(x10)
  li x12, 0xC0000000
  bne x11, x12, 1b

  # Select crystal as main clock source

  li x10, PRCI_PLLCFG
  li x11, 0x00070df1 # 0x00060df1 | (1<<16) | (1<<17) | (1<<18)  # Reset value | PLLSEL | PLLREFSEL | PLLBYPASS
  sw x11, 0(x10)

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
