
# Common Anode tied to Vcc. LEDs shine on low.
.equ green, 1<<19 # GPIO 19: Green LED
.equ blue,  1<<21 # GPIO 21: Blue LED
.equ red,   1<<22 # GPIO 22: Red LED

CODEWORD Flag_visible, "led-init", LED_INIT
  li x20, red|green|blue
  li x21, GPIO_OUTPUT_EN
  sw x20, 0(x21)
NEXT

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

CODEWORD Flag_visible, "white", WHITE
    li x20, 0
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

CODEWORD Flag_visible, "yellow", YELLOW
    li x20, blue
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

CODEWORD Flag_visible, "cyan", CYAN
    li x20, red
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

CODEWORD Flag_visible, "magenta", MAGENTA
    li x20, green
    li x21, GPIO_PORT
    sw x20, 0(x21)
NEXT

