CODEWORD Flag_visible, "abs", ABS @ ( n1 -- |n1| )
  cmp tos, #0
  it mi
  rsbsmi tos, tos, #0
NEXT
