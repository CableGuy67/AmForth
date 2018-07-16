
CODEWORD Flag_visible, "1ms", 1MS

  li x7, 10000000
1:
  addi x7,x7,-1
  bne x7,zero,1b
NEXT
