# -----------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_variable, "state" # ( -- addr )
  CoreVariable state
# -----------------------------------------------------------------------------
  savetos
  li x3, state
  NEXT
  .word 0
