
CODEWORD Flag_visible, "1ms", 1MS

  li x7, 10000000 # approx 1s, for the hifive1-board
  li x7, 100000 # approx 0.01s, for the hifive1-board
1:
  addi x7,x7,-1
  bne x7,zero,1b
NEXT
