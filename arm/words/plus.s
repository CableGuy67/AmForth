@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "+", PLUS @ ( x1 x2 -- x1+x2 )
                      @ Adds x1 and x2.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  adds tos, r0
  NEXT
  adds tos, r0 @ Opcode for use with literal in register
  adds tos, #0 @ Opcode for use with byte literal

  .ifndef m0core @ Opcode with 12-bit encoded constant only available on M3/M4
  .hword 0x0600
  .hword 0xF116
  .endif @ Opcode adds tos, tos, #imm12
