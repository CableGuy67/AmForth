CODEWORD "2>r", 2TO_R @ Puts the two top elements of stack on returnstack.
  ldm psp!, {r0}
  push {r0}
  push {tos}
  ldm psp!, {tos}
NEXT
