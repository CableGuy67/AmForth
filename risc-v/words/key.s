#------------------------------------------------------------------------------
  CODEWORD Flag_visible, "key",KEY # ( -- c )
key:
#------------------------------------------------------------------------------
#  li x5, hook_key
#  lw x5, 0(x5)
#  jalr zero, x5, 0
   j PFA_SERIAL_KEY