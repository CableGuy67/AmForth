@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ Logikfunktionen
@ Logic.

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "and",AND @ ( x1 x2 -- x1&x2 )
                        @ Combines the top two stack elements using bitwise AND.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  ands tos, r0
NEXT

  ands tos, r0 @ Opcode for use with literal in register

  .ifndef m0core @ Opcode with 12-bit encoded constant only available on M3/M4
  .hword 0x0600
  .hword 0xF016
  .endif @ Opcode ands tos, tos, #imm12

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "or",OR @ ( x1 x2 -- x1|x2 )
                       @ Combines the top two stack elements using bitwise OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  orrs tos, r0
NEXT

  orrs tos, r0 @ Opcode for use with literal in register

  .ifndef m0core @ Opcode with 12-bit encoded constant only available on M3/M4
  .hword 0x0600
  .hword 0xF056
  .endif @ Opcode orrs tos, tos, #imm12

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "xor",XOR @ ( x1 x2 -- x1|x2 )
                        @ Combines the top two stack elements using bitwise exclusive-OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  eors tos, r0
  NEXT

  eors tos, r0 @ Opcode for use with literal in register

  .ifndef m0core @ Opcode with 12-bit encoded constant only available on M3/M4
  .hword 0x0600
  .hword 0xF096
  .endif @ Opcode eors tos, tos, #imm12


@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "not",NOT @ ( x -- ~x )
@ -----------------------------------------------------------------------------
  mvns tos, tos
NEXT

CODEWORD Flag_visible, "invert", INVERT
  mvns tos,tos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "rshift",RSHIFT @ ( x n -- x )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  lsrs r0, tos
  movs tos, r0
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "lshift",LSHIFT @ ( x n -- x )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  lsls r0, tos
  movs tos, r0
NEXT
