# -----------------------------------------------------------------------------
  CODEWORD Flag_foldable_2, "-", MINUS # ( x1 x2 -- x1-x2 )
                      # Subtracts x2 from x1.
# -----------------------------------------------------------------------------
minus:
  lw x5, 0(x4)
  addi x4, x4, 4
  sub x3, x5, x3
  NEXT