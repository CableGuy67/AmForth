#------------------------------------------------------------------------------
  COLON Flag_visible, "key",KEY # ( -- c )
#------------------------------------------------------------------------------

    .word XT_SERIAL_KEYQ, XT_DOCONDBRANCH, PFA_KEY
    .word XT_SERIAL_KEY
    .word XT_EXIT
