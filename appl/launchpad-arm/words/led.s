
   .equ SYSCTL_RCGC2_R , 0x400FE108
   .equ SYSCTL_RCGC2_GPIOF, 0x00000020
   .equ GPIO_PORTF_DIR_R, 0x40025400
   .equ GPIO_PORTF_DATA_R,0x400253FC
   .equ GPIO_PORTF_DEN_R, 0x4002551C
   .equ LED_ALL, 0x0e
   .equ LED_GREEN, 0x08
   .equ LED_BLUE, 0x04
   .equ LED_RED, 0x02


CODEWORD Flag_visible, "led-init", LED_INIT
   ldr r0, =SYSCTL_RCGC2_R
   ldr r1, =SYSCTL_RCGC2_GPIOF
   str r1, [r0]
   ldr r0, =GPIO_PORTF_DIR_R
   ldr r1, =LED_ALL
   str r1, [r0]
   ldr r0, =GPIO_PORTF_DEN_R
   str r1, [r0]
NEXT

CODEWORD Flag_visible,"green", GREEN
   ldr r1, =LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible,"blue", BLUE
   ldr r1, =LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible,"red", RED
   ldr r1, =LED_RED
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible, "white", WHITE
   ldr r1, =LED_RED+LED_GREEN+LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible, "yellow", YELLOW
   ldr r1, =LED_RED+LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible, "cyan", CYAN
   ldr r1, =LED_BLUE+LED_GREEN
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible, "magenta", MAGENTA
   ldr r1, =LED_RED+LED_BLUE
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT

CODEWORD Flag_visible, "black", BLACK
   ldr r1, =0
   ldr r0, =GPIO_PORTF_DATA_R
   str r1, [r0]
   NEXT
