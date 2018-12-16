CODEWORD "2dup", 2DUP @ ( 2 1 -- 2 1 2 1 )
  ldr r0, [psp]
  savetos
  sub psp, #4
  str r0, [psp]
NEXT
