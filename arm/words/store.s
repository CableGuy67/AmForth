@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "!", STORE @ ( x 32-addr -- )
@ Given a value 'x' and a cell-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  str r0, [tos]      @ Popping both saves a cycle.
  movs tos, r1
NEXT

  @ For opcoding with one constant
  str tos, [r0]
NEXT

  @ For opcoding with two constants
  str r1, [r0]
NEXT
