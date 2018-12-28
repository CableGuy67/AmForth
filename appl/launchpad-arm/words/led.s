

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



   .equ SYSCTL_RCGC2_R , 0x400FE108
   .equ SYSCTL_RCGC2_GPIOF, 0x00000020
   .equ GPIO_PORTF_DIR_R, 0x40025400
   .equ GPIO_PORTF_DATA_R,0x400253FC
   .equ GPIO_PORTF_DEN_R, 0x4002551C
   .equ LED_ALL, 0x0e
   .equ LED_GREEN, 0x08
   .equ LED_BLUE, 0x04
   .equ LED_RED, 0x02


CODEWORD  "led-init", LED_INIT
   ldr r0, =SYSCTL_RCGC2_R
   ldr r1, =SYSCTL_RCGC2_GPIOF
   str r1, [r0]
   ldr r0, =GPIO_PORTF_DIR_R
   ldr r1, =LED_ALL
   str r1, [r0]
   ldr r0, =GPIO_PORTF_DEN_R
   str r1, [r0]
NEXT

CODEWORD "green", GREEN
   ldr r1, =LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD "blue", BLUE
   ldr r1, =LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD "red", RED
   ldr r1, =LED_RED
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD  "white", WHITE
   ldr r1, =LED_RED+LED_GREEN+LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD  "yellow", YELLOW
   ldr r1, =LED_RED+LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD  "cyan", CYAN
   ldr r1, =LED_BLUE+LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD  "magenta", MAGENTA
   ldr r1, =LED_RED+LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD  "black", BLACK
   ldr r1, =0
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT
