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
