CODEWORD Flag_visible, "abs", ABS @ ( n1 -- |n1| )
  .ifdef m0core
  cmp tos, #0
  bpl 1f
  rsbs tos, tos, #0
1: NEXT
  .else
  cmp tos, #0
  it mi
  rsbsmi tos, tos, #0
NEXT
  .endif
