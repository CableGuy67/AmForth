#------------------------------------------------------------------------------
  CODEWORD Flag_inline, "r@", R_FETCH # Kopiert das oberste Element des Returnstacks auf den Datenstack
#------------------------------------------------------------------------------
  pushdatos
  lw x3, 0(sp)
  NEXT
