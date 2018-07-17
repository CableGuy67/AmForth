
COLON Flag_visible, "warm", WARM
  .word XT_LED_INIT
  .word XT_INIT_USART
PFA_WARM_LOOP:
  .word XT_DOLITERAL, 42
  .word XT_SERIAL_EMIT
  .word XT_DOLITERAL,3,XT_SPACES
  .word XT_DOBRANCH
  .word PFA_WARM_LOOP
  .word XT_EXIT
