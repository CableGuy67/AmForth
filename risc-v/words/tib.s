# -----------------------------------------------------------------------------
  CODEWORD Flag_foldable_0, "tib", TIB # ( -- addr )
# -----------------------------------------------------------------------------
tib:
  pushdaconst Eingabepuffer
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_variable, ">in", TO_IN # ( -- addr )
  CoreVariable Pufferstand
# -----------------------------------------------------------------------------
source_in:
  pushdaconst Pufferstand
  NEXT
  .word 0

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_2variable, "current-source", CURRENT_SOURCE # ( -- addr )
  DoubleCoreVariable current_source
#------------------------------------------------------------------------------
  pushdaconst current_source
  NEXT
  .word 0              # Empty TIB for default
  .word Eingabepuffer
