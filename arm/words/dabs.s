@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "dabs", DABS
@------------------------------------------------------------------------------
  cmp tos, #0   @ Check sign in high-part
  bmi dnegate @ Not negative ? Nothing to do !
NEXT
