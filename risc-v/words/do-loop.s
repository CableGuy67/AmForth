
CODEWORD Flag_visible, "(loop)", DOLOOP
  li x5, 1
  j DOPLUSLOOP

CODEWORD Flag_visible, "(+loop)", DOPLUSLOOP
  mv x5, x3
  loadtos
DOPLUSLOOP:
  add x8,x8,x5
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
