#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_2, "dabs", DABS
#------------------------------------------------------------------------------
dabs:
  blt x3, zero, dnegate # Check sign in high-part
  NEXT                  # Not negative ? Nothing to do !
