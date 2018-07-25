#------------------------------------------------------------------------------
  CODEWORD Flag_visible, "dabs", DABS
#------------------------------------------------------------------------------
dabs:
  blt x3, zero, PFA_DNEGATE # Check sign in high-part
  NEXT                  # Not negative ? Nothing to do !
