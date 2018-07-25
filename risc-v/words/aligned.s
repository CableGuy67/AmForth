  CODEWORD Flag_visible, "aligned", ALIGNED # ( c-addr -- a-addr )
  andi x5, x3, 1
  add x3, x3, x5
  andi x5, x3, 2
  add x3, x3, x5
  NEXT
