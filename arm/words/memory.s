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

@ Speicherzugriffe aller Art
@ Memory access


@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "move",MOVE  @ Move some bytes around. This can cope with overlapping memory areas.
@------------------------------------------------------------------------------

  push {r0, r1, r2}

  popda r1 @ Count
  popda r2 @ Destination address
  @ TOS:     Source address

  @ Count > 0 ?
  cmp r1, #0
  beq 3f @ Nothing to do if count is zero.

  @ Compare source and destination address to find out which direction to copy.
  cmp r2, tos
  beq 3f @ If source and destionation are the same, nothing to do.
  blo 2f

  subs tos, #1
  subs r2, #1

1:@ Source > Destination --> Backward move
  ldrb r0, [tos, r1]
  strb r0, [r2, r1]
  subs r1, #1
  bne 1b
  b 3f

2:@ Source < Destination --> Forward move
  ldrb r0, [tos]
  strb r0, [r2]
  adds tos, #1
  adds r2, #1
  subs r1, #1
  bne 2b

3:  ldm psp!, {tos}
  pop {r0, r1, r2}
  NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "fill",FILL  @ Fill memory with given byte.
  @ ( Destination Count Filling -- )
@------------------------------------------------------------------------------
  popda r0 @ Filling byte
  popda r1 @ Count
  @ TOS      Destination

  cmp r1, #0
  beq 2f

1:subs r1, #1
  strb r0, [tos, r1]
  bne 1b

2:  ldm psp!, {tos}

NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "+!", PLUSSTORE @ ( x 32-addr -- )
                               @ Adds 'x' to the memory cell at 'addr'.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  ldr  r2, [tos]     @ Load the current cell value
  adds r2, r0        @ Do the add
  str  r2, [tos]     @ Store it back
  movs tos, r1
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "c@", CFETCH @ ( 8-addr -- x )
                              @ Loads the byte at 'addr'.
@ -----------------------------------------------------------------------------
  ldrb tos, [tos]
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "c!", CSTORE @ ( x 8-addr -- )
@ Given a value 'x' and an 8-bit-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  strb r0, [tos]     @ Popping both saves a cycle.
  movs tos, r1
NEXT
