
HEADLESS DOLOOP
  li x5, 1
  j PFA_DOPLUSLOOP1

HEADLESS DOPLUSLOOP
  mv x5, x3
  loadtos
PFA_DOPLUSLOOP1:
  add x8,x8,x5
  bge  x8,x9,PFA_DOLOOP_LEAVE
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
