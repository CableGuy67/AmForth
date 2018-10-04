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

@ Vergleichsoperatoren
@ Comparision operators

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "0=", ZEROEQUAL @ ( x -- ? )
@ -----------------------------------------------------------------------------
@        subs TOS, TOS, #1       ; if zero, carry is set, else carry is clear
@        sbc TOS, TOS, TOS       ; subtracting r0 from itself leaves zero if
@                                ; carry was clear or -1 if carry was set.
  subs tos, #1
  sbcs tos, tos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "0<>", NOTZEROEQUAL @ ( x -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  subs tos, #1
  sbcs tos, tos
  mvns tos, tos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "0<", ZEROLESS @ ( n -- ? )
@ -----------------------------------------------------------------------------
  movs tos, tos
  asr tos, #32    @ Turn MSB into 0xffffffff or 0x00000000
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, ">=", GREATEREQUAL @ ( x1 x2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}      @ Get x1 into a register.
  cmp r0, tos         @ Is x2 less?
  bge 1f
  movs tos, #0
NEXT
1:movs tos, #0
  mvns tos, tos
NEXT
  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #0      @  set all bits in TOS,
  movge tos, #-1     @  otherwise clear them all.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "<=", LESSEQUAL @ ( x1 x2 -- ? ) @ Meins          
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ble 1f  
  movs tos, #0
NEXT
1:movs tos, #0
  mvns tos, tos
NEXT
  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #0      @  set all bits in TOS,
  movle tos, #-1     @  otherwise clear them all.
NEXT

  .endif


@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "<", LESS @ ( x1 x2 -- ? )
                      @ Checks if x2 is less than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  bge 1f
  movs tos, #0
  mvns tos, tos
NEXT
1:movs tos, #0
NEXT
  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #-1     @  set all bits in TOS,
  movge tos, #0      @  otherwise clear them all.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, ">", GREATER @ ( x1 x2 -- ? )
                      @ Checks if x2 is greater than x1.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ble 1f
  movs tos, #0
  mvns tos, tos
NEXT
1:movs tos, #0
NEXT
  .else
  ldm psp!, {r0}     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #-1     @  set all bits in TOS,
  movle tos, #0      @  otherwise clear them all.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "u<", ULESS @ ( u1 u2 -- ? )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}      @ Get u1 into a register.
  subs tos, r0, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
NEXT
@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "u>", UGREATER @ ( u1 u2 -- ? ) @ Meins
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  subs tos, r0
  sbcs tos, tos
NEXT
@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "<>", NOTEQUAL @ ( x1 x2 -- ? )
                       @ Compares the top two stack elements for inequality.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}      @ Get the next elt into a register.
  subs tos, r0        @ Z=equality; if equal, TOS=0

  .ifdef m0core
  beq 1f
  movs tos, #0
  mvns tos, tos
1:NEXT
  .else
  it ne             @ If not equal,
  movne tos, #-1    @  set all bits in TOS.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "=", EQUAL @ ( x1 x2 -- ? )
                      @ Compares the top two stack elements for equality.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}     @ Get the next elt into a register.
  subs tos, r0       @ Z=equality; if equal, TOS=0

  subs tos, #1       @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
NEXT
@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "min", MIN @ ( x1 x2 -- x3 )
                        @ x3 is the lesser of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare them.
  bge 1f
  movs tos, r0
1:NEXT

  .else
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare them.
  it lt                @ If X is less,
  movlt tos, r0        @  replace TOS with it.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "max", MAX @ ( x1 x2 -- x3 )
                        @ x3 is the greater of x1 and x2.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.  
  blt 1f
  movs tos, r0
1:NEXT

  .else
  ldm psp!, {r0}       @ Get x1 into a register.
  cmp r0, tos          @ Compare 'em.
  it gt                @ If X is greater,
  movgt tos, r0        @  replace TOS with it.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "umax", UMAX @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos 
  blo 1f
  movs tos, r0
1:NEXT

  .else
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos 
  it hi           @ If W > TOS,
  movhi tos, r0   @  replace TOS with W.
NEXT
  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "umin",UMIN @ ( u1 u2 -- u1|u2 )
@ -----------------------------------------------------------------------------
  .ifdef m0core
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos 
  bhi 1f
  movs tos, r0
1:NEXT

  .else
  ldm psp!, {r0}  @ Get u1 into a register.
  cmp r0, tos
  it lo           @ If W < TOS,
  movlo tos, r0   @  replace TOS with W.
NEXT
  .endif
