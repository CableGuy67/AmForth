
COLON Flag_visible, "warm", WARM
  .word XT_LED_INIT
  .word XT_INIT_USART
PFA_WARM_LOOP:
  .word XT_RED
  .word XT_DOLITERAL, 50
  .word XT_MS
  .word XT_BLUE
  .word XT_DOLITERAL, 42
  .word XT_SERIAL_EMIT
  .word XT_DOLITERAL, 50
  .word XT_MS
  .word XT_GREEN
  .word XT_DOLITERAL, 50
  .word XT_MS
  .word XT_DOLITERAL
  .word XT_CR
  .word XT_EXECUTE
  .word XT_DOBRANCH
  .word PFA_WARM_LOOP
  .word XT_YELLOW
  .word XT_EXIT
