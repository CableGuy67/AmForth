# -----------------------------------------------------------------------------
  CODEWORD Flag_foldable_0, "tib", TIB # ( -- addr )
# -----------------------------------------------------------------------------
tib:
  pushdaconst Eingabepuffer
  NEXT


#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_2variable, "current-source", CURRENT_SOURCE # ( -- addr )
  DoubleCoreVariable current_source
#------------------------------------------------------------------------------
  pushdaconst current_source
  NEXT
  .word 0              # Empty TIB for default
  .word Eingabepuffer

  VARIABLE ">in", TO_IN # ( -- addr )
