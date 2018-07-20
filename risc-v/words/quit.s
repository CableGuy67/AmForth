COLON Flag_visible, "quit", QUIT

PFA_QUIT_LOOP:
  .word XT_DOT_VER, XT_CR
  .word XT_BUILD_INFO,XT_TYPE

  .word XT_DOLITERAL, 42
  .word XT_SERIAL_EMIT
  .word XT_DOLITERAL,2,XT_SPACES
  .word XT_CR, XT_HEX
  .word XT_DOLITERAL, 0xdeadbeef, XT_UDOT
  .word XT_DOLITERAL,1000,XT_MS
  .word XT_DOBRANCH
  .word PFA_QUIT_LOOP
