# -----------------------------------------------------------------------------
  CODEWORD Flag_foldable_1|Flag_inline, "2-", 2MINUS # ( u -- u-1 )
                      # Subtracts two from the cell on top of the stack.
# -----------------------------------------------------------------------------
  addi x3, x3, -2
  NEXT
