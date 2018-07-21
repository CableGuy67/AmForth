# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "tib", TIB # ( -- addr )
# -----------------------------------------------------------------------------
  savetos
  li x3, RAM_lower_refill_buf
  NEXT

VARIABLE "#tib", NUMBERTIB
VARIABLE ">in", TO_IN 
