COLON Flag_visible, "?stack", QSTACK

    .word XT_DEPTH
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH,PFA_QSTACK1
      .word XT_DOLITERAL
      .word -4
      .word XT_THROW
PFA_QSTACK1:
    .word XT_EXIT
