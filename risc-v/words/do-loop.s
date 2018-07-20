
CODEWORD Flag_visible, "(loop)", DOLOOP
  addi x8,x8,1
  beq  x8,x9,DOLOOP_LEAVE
  lw x16,0(x16)
  NEXT
DOLOOP_LEAVE:
  # restore loop-sys
  lw x10, 0(sp)
  lw x9, 4(sp)
  lw x8, 8(sp)
  addi sp, sp, 12

  # skip loop address
  addi x16,x16,4
NEXT