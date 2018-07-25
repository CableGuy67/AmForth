

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "depth", DEPTH # ( -- Zahl der Elemente, die vorher auf den Datenstack waren )
                                  # ( -- Number of elements that have been on datastack before )
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  li x5, RAM_upper_datastack # Anfang laden  Calculate stack fill gauge
  sub x5, x5, x4            # und aktuellen Stackpointer abziehen
  savetos
  srai x3, x5, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "rdepth", RDEPTH
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  li x5, RAM_upper_returnstack # Anfang laden  Calculate stack fill gauge
  sub x5, x5, sp          # und aktuellen Stackpointer abziehen
  savetos
  srai x3, x5, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT


#------------------------------------------------------------------------------
  CODEWORD Flag_visible, "rdrop", RDROP # Entfernt das oberste Element des Returnstacks
#------------------------------------------------------------------------------
  addi sp, sp, 4
  NEXT
