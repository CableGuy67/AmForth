
.equ UART0BASE, 0x10013000

.equ UART0_TXDATA    , UART0BASE + 0x00
.equ UART0_RXDATA    , UART0BASE + 0x04
.equ UART0_TXCTRL    , UART0BASE + 0x08
.equ UART0_RXCTRL    , UART0BASE + 0x0C
.equ UART0_IE        , UART0BASE + 0x10
.equ UART0_IP        , UART0BASE + 0x14
.equ UART0_DIV       , UART0BASE + 0x18

.equ RCGCPIO,    0x400FE608
.equ RCGCUART,   0x400FE618

.equ GPIOA_BASE, 0x40004000
.equ GPIOAFSEL,  0x40004420
.equ GPIODEN,    0x4000451C

.equ Terminal_UART_Base, 0x4000C000 @ UART 0

.equ UART0_BASE, 0x4000C000
.equ UARTDR,     Terminal_UART_Base + 0x000
.equ UARTFR,     Terminal_UART_Base + 0x018
.equ UARTIBRD,   Terminal_UART_Base + 0x024
.equ UARTFBRD,   Terminal_UART_Base + 0x028
.equ UARTLCRH,   Terminal_UART_Base + 0x02C
.equ UARTCTL,    Terminal_UART_Base + 0x030
.equ UARTCC,     Terminal_UART_Base + 0xFC8


CODEWORD  "uart-init", UART_INIT

  @ Baud rate generation:
  @ 16000000 / (16 * 115200 ) = 1000000 / 115200 = 8.6805
  @ 0.6805... * 64 = 43.5   ~ 44

  @ 16000000 / (16 * 38400 ) = 1000000 / 38400 = 20.04167
  @ 0.4167.. * 64 = 2,67   ~ 3

  @ use 3 and 20

  movs r1, #1         @ UART0 aktivieren
  ldr  r0, =RCGCUART
  str  r1, [r0]

  movs r1, #0x3F      @ Alle GPIO-Ports aktivieren
  ldr  r0, =RCGCPIO
  str  r1, [r0]

  movs r1, #3         @ PA0 und PA1 auf UART-Sonderfunktion schalten
  ldr  r0, =GPIOAFSEL
  str  r1, [r0]

  @ movs r1, #3       @ PA0 und PA1 als digitale Leitungen aktivieren
  ldr  r0, =GPIODEN
  str  r1, [r0]

   @ UART-Einstellungen vornehmen

  movs r1, #0         @ UART stop
  ldr  r0, =UARTCTL
  str  r1, [r0]

  @ Baud rate generation:
  @ 16000000 / (16 * 115200 ) = 1000000 / 115200 = 8.6805
  @ 0.6805... * 64 = 43.5   ~ 44

  @ 16000000 / (16 * 38400 ) = 1000000 / 38400 = 20.04167
  @ 0.4167.. * 64 = 2,67   ~ 3

  @ use 3 and 20

  movs r1, #8
  ldr  r0, =UARTIBRD
  str r1, [r0]

  movs r1, #44
  ldr  r0, =UARTFBRD
  str r1, [r0]

  movs r1, #0x60|0x10  @ 8N1, enable FIFOs !
  ldr  r0, =UARTLCRH
  str r1, [r0]

  movs r1, #5          @ Choose PIOSC as source
  ldr  r0, =UARTCC
  str r1, [r0]

  movs    r1, #0
  ldr     r0, =UARTFR
  str r1, [r0]

  movw r1, #0x301      @ UART start
  ldr  r0, =UARTCTL
  str  r1, [r0]
NEXT
@ -----------------------------------------------------------------------------
  CODEWORD  "serial-key", SERIAL_KEY
@ -----------------------------------------------------------------------------

   savetos

   ldr r0, =UARTDR    @ Einkommendes Zeichen abholen
   ldr tos, [r0]      @ Register lesen
   uxtb tos, tos      @ 8 Bits davon nehmen, Rest mit Nullen auffüllen.
  
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-key?", SERIAL_KEYQ
@ -----------------------------------------------------------------------------
   savetos
   movs tos, #0
   ldr r0, =UARTFR
   ldr r1, [r0]
   ands r1, #RXFE
   bne 1f
     mvns tos, tos
1: 
NEXT
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
