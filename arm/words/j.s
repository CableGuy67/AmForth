@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "j", J @ Kopiert den zweitobersten Schleifenindex  Second loop index
@------------------------------------------------------------------------------
  savetos
  pop {r0,r1}
  push {r0,r1}
  add tos, r0, r1
NEXT
