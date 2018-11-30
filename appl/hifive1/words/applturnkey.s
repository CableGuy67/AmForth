
COLON Flag_visible, "hifive-turnkey", APPLTURNKEY

  .word XT_LED_INIT
  .word XT_DECIMAL
  .word XT_INIT_USART

  .word XT_DOT_VER, XT_SPACE
  .word XT_ENV_BOARD,XT_TYPE, XT_CR

  .word XT_BUILD_INFO,XT_TYPE
  .word XT_SPACE, XT_REV_INFO, XT_TYPE

.word XT_EXIT
