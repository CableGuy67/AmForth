
@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "depth", DEPTH @ ( -- Zahl der Elemente, die vorher auf den Datenstack waren )
                                  @ ( -- Number of elements that have been on datastack before )
@ -----------------------------------------------------------------------------
  @ Berechne den Stackfüllstand
  ldr r1, =RAM_upper_datastack @ Anfang laden  Calculate stack fill gauge
  subs r1, psp @ und aktuellen Stackpointer abziehen
  savetos
  lsrs tos, r1, #2 @ Durch 4 teilen  Divide through 4 Bytes/element.
NEXT
