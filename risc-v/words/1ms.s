
CODEWORD Flag_visible, "1ms", 1MS

  li x5, 10000000 # approx 1s, for the hifive1-board
  li x5, 10000 # approx 0.001s, for the hifive1-board
1:
  addi x5,x5,-1
  bne x5,zero,1b
NEXT
