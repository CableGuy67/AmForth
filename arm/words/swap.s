@ -----------------------------------------------------------------------------
  CODEWORD "swap", SWAP @ ( x y -- y x )
@ -----------------------------------------------------------------------------
  ldr r1,  [psp]  @ Load X from the stack, no SP change.
  str tos, [psp]  @ Replace it with TOS.
  movs tos, r1    @ And vice versa.
NEXT
