
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


CODEWORD Flag_visible, "red", RED
    li x20, blue|green
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

CODEWORD Flag_visible, "green", GREEN
    li x20, blue|red
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

CODEWORD Flag_visible, "blue", BLUE
    li x20, red|green
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT
