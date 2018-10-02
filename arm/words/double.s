

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "um*", UMSTAR
  @ Multiply unsigned 32*32 = 64
  @ ( u u -- ud )
@------------------------------------------------------------------------------

  bl um_star
NEXT

um_star:
    push {lr}
    ldr r0, [psp]  @ To be calculated: Tos * r0

    @ Calculate low part in hardware:
    movs r3, r0    @ Save the low part for later
    muls r3, tos   @ Gives complete low-part of result
    str r3, [psp]  @ Store low part

    @ Calculate high part:
    lsrs r1, r0,  #16 @ Shifted half
    lsrs r2, tos, #16 @ Shifted half

    movs r3, r1  @ High-High
    muls r3, r2

    @ Low-High and High-Low
    uxth tos, tos
    uxth r0, r0

    muls tos, r1
    muls r0, r2
    adds tos, r0

    lsrs tos, #16 @ Shift accordingly
    adds tos, r3  @ Add together
    pop {pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "m*", MSTAR
  @ Multiply signed 32*32 = 64
  @ ( n n -- d )
@------------------------------------------------------------------------------
  bl m_star
NEXT

m_star:
    push {lr}
    ldr r0, [psp]
    movs r1, r0, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 1f
    @ - * ?
      rsbs r0, r0, #0
      str r0, [psp]

      movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
      beq 2f @ - * +

      @ - * -
      rsbs tos, tos, #0
      b um_star

1:  @ + * ?
    movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq um_star @ + * +
    @ + * -
    rsbs tos, tos, #0

    @ - * + or + * -
2:  push {lr}
    bl um_star
    bl dnegate
    pop {pc}

@
CODEWORD Flag_visible, "udm*", UDMSTAR
  bl ud_star
NEXT
ud_star: @ Unsigned multiply 64*64 = 128
         @ ( ud1 ud2 -- udl udh )
@------------------------------------------------------------------------------
  @ Auf dem Datenstack: ( 1L 1H 2L 2H -- LL  L  H HH )
  @                       12  8  4  0 nach pushdatos
  @                        d  c  b  a    r0 r1 r2 r3
  @ Benötige einen langen Ergebnisregister !

  push {r4, lr}
  movs r4, #0 @ For Carry addition

  @ ( d c b a )
  savetos
  ldr tos, [psp, #4]    @ b
  savetos
  ldr tos, [psp, #12+4] @ d
  bl um_star
  @ ( d c b a  b*d-Low b*d-High )
  popda r1 @ b*d-High
  popda r0 @ b*d-Low, finished value

  @ ( d c b a )

  savetos
  ldr tos, [psp, #0]   @ a
  savetos
  ldr tos, [psp, #8+4] @ c
  push {r0, r1}
    bl um_star
  pop {r0, r1}
  @ ( d c b a  a*c-Low a*c-High )
  popda r3 @ a*c-High
  popda r2 @ a*c-Low

  @ ( d c b a )

  savetos
  ldr tos, [psp, #0]    @ a
  savetos
  ldr tos, [psp, #12+4] @ d

  push {r0, r1, r2, r3}
    bl um_star
  pop {r0, r1, r2, r3}
  @ ( d c b a  a*d-Low a*d-High )

  adds r2, tos @ a*c-Low + a*d-High
  adcs r3, r4  @ Carry
  ldm psp!, {tos}
  adds r1, tos @ a*d-Low + b*d-High
  adcs r2, r4  @ Carry
  adcs r3, r4  @ Carry
  ldm psp!, {tos}
  @ ( d c b a )

  savetos
  ldr tos, [psp, #4]    @ b
  savetos
  ldr tos, [psp, #8+4]  @ c

  push {r0, r1, r2, r3}
    bl um_star
  pop {r0, r1, r2, r3}
  @ ( d c b a  b*c-Low b*c-High )

  adds r2, tos @ a*c-Low + b*c-High + a*d-High
  adcs r3, r4  @ Carry
  ldm psp!, {tos}
  adds r1, tos @ b*c-Low + a*d-Low + b*d-High
  adcs r2, r4  @ Carry
  adcs r3, r4  @ Carry
  ldm psp!, {tos}
  @ ( d c b tos: a )
  movs tos, r3
  str r2, [psp, #0]
  str r1, [psp, #4]
  str r0, [psp, #8]

  pop {r4, pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "*/mod", STAR_SLASH_MOD @ Signed scalar
  @ ( u1 u2 u3 -- u1*u2/u3 ) With double length intermediate result
@------------------------------------------------------------------------------

  bl star_slash_mod
NEXT

star_slash_mod:
  push {lr}
  push {tos}
  ldm psp!, {tos} @ drop

  bl m_star
  savetos
  pop {tos}

  bl m_slash_mod
  pop {pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "um/mod", UMSLASHMOD
  bl um_slash_mod
NEXT

um_slash_mod: @ ( ud u -- u u ) Dividend Divisor -- Rest Ergebnis
             @ 64/32 = 32 Rest 32
@------------------------------------------------------------------------------
  push {lr}
  savetos
  movs tos, #0
  bl ud_slash_mod
  ldm psp!, {tos}
  adds psp, #4 @ Move SP to eliminate next element.
  pop {pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "m/mod", MSLASHMOD
              @ Signed symmetric divide 64/32 = 32 remainder 32
  bl m_slash_mod
NEXT

m_slash_mod:  @ ( d n -- n n )
@------------------------------------------------------------------------------
  push {lr}
  savetos                 @ s>d
  movs tos, tos, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
  bl d_slash_mod
  ldm psp!, {tos}
  adds psp, #4 @ Move SP to eliminate next element.
  pop {pc}

@------------------------------------------------------------------------------
@ Tool for ud/mod
@------------------------------------------------------------------------------

  .macro division_step
    @ Shift the long chain of four registers.
    lsls r0, #1
    adcs r1, r1
    adcs r2, r2
    adcs r3, r3

    @ Compare Divisor with top two registers
    cmp r3, r5 @ Check high part first
    bhi 1f
    blo 2f

    cmp r2, r4 @ High part is identical. Low part decides.
    blo 2f

    @ Subtract Divisor from two top registers
1:  subs r2, r4 @ Subtract low part
    sbcs r3, r5 @ Subtract high part with carry

    @ Insert a bit into Result which is inside LSB of the long register.
    adds r0, #1
2:
  .endm

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "ud/mod", UDSLASHMOD
         @ Unsigned divide 64/64 = 64 remainder 64
         @ ( ud1 ud2 -- ud ud)
         @ ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
@------------------------------------------------------------------------------
  bl ud_slash_mod
NEXT

ud_slash_mod:
   push {lr}
   push {r4, r5}

   @ ( DividendL DividendH DivisorL DivisorH -- RemainderL RemainderH ResultL ResultH )
   @   8         4         0        tos      -- 8          4          0       tos


   @ Shift-High Shift-Low Dividend-High Dividend-Low
   @         r3        r2            r1           r0

   movs r3, #0
   movs r2, #0
   ldr  r1, [psp, #4]
   ldr  r0, [psp, #8]

   @ Divisor-High Divisor-Low
   @          r5           r4

ud_slash_mod_internal:
   movs r5, tos
   ldr  r4, [psp, #0]

   @ For this long division, we need 64 individual division steps.
   movs tos, #64

3: division_step
   subs tos, #1
   bne 3b

   @ Now place all values to their destination.
   movs tos, r1       @ Result-High
   str  r0, [psp, #0] @ Result-Low
   str  r3, [psp, #4] @ Remainder-High
   str  r2, [psp, #8] @ Remainder-Low

   pop {r4, r5}
   pop {pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d/mod", DSLASHMOD
              @ Signed symmetric divide 64/64 = 64 remainder 64
              @ ( d1 d2 -- d d )
  bl d_slash_mod
NEXT

d_slash_mod:  @ ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
@------------------------------------------------------------------------------
  @ Check Divisor
  push {lr}
  movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
  beq 2f
    @ ? / -
    bl dnegate
    bl dswap
    movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 1f
    @ - / -
    bl dnegate
    bl dswap
    bl ud_slash_mod

    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

1:  @ + / -
    bl dswap
    bl ud_slash_mod
    bl dnegate  @ Negative result
    pop {pc}

2:  @ ? / +
    bl dswap
    movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 3f
    @ - / +
    bl dnegate
    bl dswap

    bl ud_slash_mod

    bl dnegate @ Negative result
    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

3:  @ + / +
    bl dswap
    bl ud_slash_mod
    pop {pc}

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d/", DSLASH
@------------------------------------------------------------------------------
  bl d_slash
NEXT

d_slash:
  push {lr}
  bl d_slash_mod
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]

  pop {pc}

@------------------------------------------------------------------------------
@ --- Double memory ---
@------------------------------------------------------------------------------

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "2!",2STORE @ Store ( d addr -- )
@------------------------------------------------------------------------------
  ldmia psp!, {r1, r2}
  str r1, [tos]
  str r2, [tos, #4]
  ldm psp!, {tos}
NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "2@",2FETCH @ Fetch ( addr -- d )
@------------------------------------------------------------------------------
  subs psp, #4
  ldr r0, [tos, #4]
  str r0, [psp]
  ldr tos, [tos]
NEXT

@------------------------------------------------------------------------------
@ --- Double comparisions ---
@------------------------------------------------------------------------------

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d<", DLESS
  @ ( 2L 2H 1L 1H -- Flag )
  @   8y 4x 0w tos
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  @ Check High:
  cmp tos, r1
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r0, r2
  bgt 2f

@ False:
1:movs tos, #0
NEXT

@ True
2:movs tos, #0
  mvns tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d>", DGREATER
  @ ( 2L 2H 1L 1H -- Flag )
  @   8y 4x 0w tos
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  @ Check High:
  cmp r1, tos
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r2, r0
  bgt 2f

@ False:
1:movs tos, #0
NEXT

@ True
2:movs tos, #0
  mvns tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d0<", DZEROLESS @ ( 1L 1H -- Flag ) Is double number negative ?
@------------------------------------------------------------------------------
  adds psp, #4
  movs TOS, TOS, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d0=", DZEROEQUAL @ ( 1L 1H -- Flag )
@------------------------------------------------------------------------------
  ldm psp!, {r0}
  cmp r0, #0
  beq 1f
    movs tos, #0
NEXT

1:subs tos, #1
  sbcs tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d=", DEQUAL @ ( 1L 1H 2L 2H -- Flag )
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  cmp r0, r2
  beq 1f
    movs tos, #0
NEXT

1:subs tos, r1       @ Z=equality; if equal, TOS=0
  subs tos, #1      @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
NEXT

CODEWORD Flag_visible, "s>d", S2D
  savetos
  movs tos, tos, asr #31
NEXT
