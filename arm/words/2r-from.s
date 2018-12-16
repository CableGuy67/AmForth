CODEWORD "2r>", 2R_FROM @ Fetches back two elements of returnstack.
  savetos
  pop {tos}
  pop {r0}
  sub psp, #4
  str r0, [psp]
NEXT
