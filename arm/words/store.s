@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "!", STORE @ ( x 32-addr -- )
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  str r0, [tos]      @ Popping both saves a cycle.
  movs tos, r1
NEXT
