
HEADLESS DOLOOP
  li x5, 1
  j PFA_DOPLUSLOOP1

HEADLESS DOPLUSLOOP
  mv x5, x3
  loadtos
PFA_DOPLUSLOOP1:
  add x6,x8,x5
  slti x11,x5,0
  slt x12,x6,x8
  bne x11, x12, PFA_DOLOOP_LEAVE
  mv x8, x6
  lw x16,0(x16)
  NEXT
PFA_DOLOOP_LEAVE:
  # restore loop-sys
  lw x9, 0(sp)
  lw x8, 4(sp)
  addi sp, sp, 8

  # skip loop address
  addi x16,x16,4
NEXT
