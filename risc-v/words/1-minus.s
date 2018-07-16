# -----------------------------------------------------------------------------
  CODEWORD Flag_foldable_1|Flag_inline, "1-", 1MINUS # ( u -- u-1 )
                      # Subtracts one from the cell on top of the stack.
# -----------------------------------------------------------------------------
  addi x3, x3, -1
  NEXT
