@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "2swap", 2SWAP @ ( 4 3 2 1 -- 2 1 4 3 )
@ -----------------------------------------------------------------------------
  bl dswap
NEXT

dswap:
  push {lr}
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
  savetos
  subs psp, #4
  str r2, [psp]
  movs tos, r1
  pop {pc}
