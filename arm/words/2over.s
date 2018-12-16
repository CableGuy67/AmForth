CODEWORD "2over", 2OVER @ ( 4 3 2 1 -- 4 3 2 1 4 3 )
  ldr r0, [psp, #8]
  savetos
  sub psp, #4
  str r0, [psp]
  ldr tos, [psp, #12]  
NEXT
