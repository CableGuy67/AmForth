
COLON Flag_visible, "warm", WARM
  .word XT_LED_INIT
PFA_WARM_LOOP:
  .word XT_RED
  .word XT_1MS 
  .word XT_INIT_USART
  .word XT_BLUE
  .word XT_DOLITERAL, 42
  .word XT_SERIAL_EMIT
  .word XT_DOLITERAL, 5
  .word XT_MS
  .word XT_GREEN
  .word XT_1MS
  .word XT_DOBRANCH
  .word PFA_WARM_LOOP
  .word XT_BLUE
  .word XT_EXIT
