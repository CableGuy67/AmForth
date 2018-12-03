HEADLESS DOLOOP
  ldr r0, =#1
  b PFA_DOPLUSLOOP_INTERN

HEADLESS DOPLUSLOOP
  mov r0, tos
  loadtos

PFA_DOPLUSLOOP_INTERN:
  adds rloopindex, r0
  bvs PFA_DOPLUSLOOP_LEAVE
  ldr FORTHIP, [FORTHIP]
NEXT

PFA_DOPLUSLOOP_LEAVE:
  add FORTHIP, #4
  pop {rloopindex, rlooplimit}
NEXT
