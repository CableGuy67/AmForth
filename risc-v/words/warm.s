
COLON Flag_visible, "warm", WARM
  .word XT_LED_INIT
  .word XT_YELLOW
  .word XT_INIT_USART
PFA_WARM_LOOP:
  .word XT_DOT_VER, XT_CR
  .word XT_BUILD_INFO,XT_TYPE

  .word XT_DOLITERAL, 42
  .word XT_SERIAL_EMIT
  .word XT_DOLITERAL,2,XT_SPACES
  .word XT_CR
  .word XT_DOLITERAL,1000,XT_MS
  .word XT_DOBRANCH
  .word PFA_WARM_LOOP
  .word XT_EXIT
