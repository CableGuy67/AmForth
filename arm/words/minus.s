@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "-", MINUS @ ( x1 x2 -- x1-x2 )
                      @ Subtracts x2 from x1.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  subs tos, r0, tos
NEXT
  subs tos, r0 @ Opcode for use with literal in register
  subs tos, #0 @ Opcode for use with byte literal

  .ifndef m0core @ Opcode with 12-bit encoded constant only available on M3/M4
  .hword 0x0600
  .hword 0xF1B6
  .endif @ Opcode subs tos, tos, #imm12
