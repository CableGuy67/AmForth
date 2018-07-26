
COLON Flag_visible, "hifive-turnkey", APPLTURNKEY

  .word XT_LED_INIT
  .word XT_WHITE
  .word XT_DECIMAL
  .word XT_INIT_USART

  .word XT_DOT_VER
#  .word XT_CR,XT_DOLITERAL,0x100c,XT_FETCH,XT_TYPE0
  .word XT_BUILD_INFO,XT_TYPE
.word XT_EXIT
