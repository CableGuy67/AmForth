@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "i", I @ Kopiert den obersten Schleifenindex       Innermost loop index
@------------------------------------------------------------------------------
  savetos
  mov tos, rloopindex 
  add tos, rlooplimit
NEXT
