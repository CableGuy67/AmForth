CODEWORD Flag_visible, "2r>", 2R_FROM @ Fetches back two elements of returnstack.
  savetos
  pop {tos}
  pop {r0}
  subs psp, #4
  str r0, [psp]
NEXT
