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
