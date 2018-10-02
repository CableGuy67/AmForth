@------------------------------------------------------------------------------
  CODEWORD Flag_visible, ">r", TO_R @ Legt das oberste Element des Datenstacks auf den Returnstack.
@------------------------------------------------------------------------------
  push {tos}
  ldm psp!, {tos}
NEXT
