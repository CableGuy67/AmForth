#------------------------------------------------------------------------------
  CODEWORD Flag_visible, "pause",PAUSE # ( -- ? )
pause:
#------------------------------------------------------------------------------
# li x5, hook_pause
#  lw x5, 0(x5)
#  jalr zero, x5, 0
  j PFA_NOP