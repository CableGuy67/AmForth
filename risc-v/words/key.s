#------------------------------------------------------------------------------
  COLON Flag_visible, "key",KEY # ( -- c )
#------------------------------------------------------------------------------

    .word XT_RED,XT_SERIAL_KEYQ, XT_RED,XT_DOCONDBRANCH, PFA_KEY
    .word XT_GREEN
    .word XT_SERIAL_KEY
    .word XT_EXIT
