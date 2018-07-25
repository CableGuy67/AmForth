  CODEWORD Flag_visible, "2r@", 2RFETCH # ( -- 2 1 R: 2 1 -- 2 1 )
  savetos
  lw x3, 4(sp)
  savetos
  lw x3, 0(sp)
  NEXT
