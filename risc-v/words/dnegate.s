#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_2, "dnegate", DNEGATE
#------------------------------------------------------------------------------
dnegate:

  lw x5, 0(x4) # Low
  xori x5, x5, -1
  xori x3, x3, -1
  sw x5, 0(x4)

  savetos
  li x3, 1
  savetos
  li x3, 0

  j dplus
