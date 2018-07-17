
# -----------------------------------------------------------------------------
# Labels for a few hardware ports
# -----------------------------------------------------------------------------

.equ GPIOBASE, 0x10012000

.equ GPIO_VALUE        , GPIOBASE + 0x00
.equ GPIO_INPUT_EN     , GPIOBASE + 0x04
.equ GPIO_OUTPUT_EN    , GPIOBASE + 0x08
.equ GPIO_PORT         , GPIOBASE + 0x0C
.equ GPIO_PUE          , GPIOBASE + 0x10
.equ GPIO_IOF_EN       , GPIOBASE + 0x38
.equ GPIO_IOF_SEL      , GPIOBASE + 0x3C
.equ GPIO_OUT_XOR      , GPIOBASE + 0x40

  # Common Anode tied to Vcc. LEDs shine on low.
.equ green, 1<<19 # GPIO 19: Green LED
.equ blue,  1<<21 # GPIO 21: Blue LED
.equ red,   1<<22 # GPIO 22: Red LED

.equ UART0BASE, 0x10013000

.equ UART0_TXDATA    , UART0BASE + 0x00
.equ UART0_RXDATA    , UART0BASE + 0x04
.equ UART0_TXCTRL    , UART0BASE + 0x08
.equ UART0_RXCTRL    , UART0BASE + 0x0C
.equ UART0_IE        , UART0BASE + 0x10
.equ UART0_IP        , UART0BASE + 0x14
.equ UART0_DIV       , UART0BASE + 0x18

.equ PRCI_BASE, 0x10008000

.equ PRCI_HFROSCCFG  , PRCI_BASE + 0x00
.equ PRCI_HFXOSCCFG  , PRCI_BASE + 0x04
.equ PRCI_PLLCFG     , PRCI_BASE + 0x08
.equ PRCI_PLLDIV     , PRCI_BASE + 0x0C
.equ PRCI_PROCMONCFG , PRCI_BASE + 0xF0


.include "words/uart-init.s"
.include "words/usart-rx-poll.s"
.include "words/usart-tx-poll.s"
