
COLON Flag_visible,"appl-turnkey", APPLTURNKEY
  .word XT_DECIMAL, XT_HEX
  .word XT_LED_INIT, XT_UART_INIT
  .word XT_DOT_VER

  STRING " LM4F120XL"
  .word XT_TYPE, XT_CR
  .word XT_BUILD_INFO,XT_TYPE
  .word XT_RED, XT_WORDS
.word XT_EXIT
