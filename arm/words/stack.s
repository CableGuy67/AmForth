
CODEWORD Flag_visible, "depth", DEPTH 
  ldr r1, =RAM_upper_datastack 
  sub r1, psp 
  savetos
  asrs tos, r1, #2 
NEXT

CODEWORD Flag_visible, "rdepth", RDEPTH
  savetos
  mov tos, sp
  ldr r1, =RAM_upper_returnstack
  sub r1, tos 
  asrs tos, r1, #2 
NEXT

CODEWORD Flag_visible, "rdrop", RDROP
  add sp, #4
NEXT
