HEADLESS DOLOOP
  ldr r0, =#1
  b PFA_DOPLUSLOOP_INTERN

HEADLESS DOPLUSLOOP
  mov r0, tos
  loadtos

PFA_DOPLUSLOOP_INTERN:
  add rloopindex, r0
  cmp rloopindex,rlooplimit
  bge PFA_DOPLUSLOOP1
  ldr FORTHIP, [FORTHIP]
NEXT

PFA_DOPLUSLOOP1:
  add FORTHIP, #4
  pop {rloopindex, rlooplimit}
NEXT
