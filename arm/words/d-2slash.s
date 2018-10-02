@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d2/", D2SLASH
@------------------------------------------------------------------------------
  ldr r0, [psp]
  lsls r1, tos, #31 @ Prepare Carry
  asrs tos, #1     @ Shift signed high part right
  lsrs r0, #1       @ Shift low part
  orrs r0, r1
  str r0, [psp]
NEXT
