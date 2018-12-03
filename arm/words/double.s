

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "um*", UMSTAR
  @ Multiply unsigned 32*32 = 64
  @ ( u u -- ud )
@------------------------------------------------------------------------------
    ldr r0, [psp]  @ To be calculated: Tos * r0
    umull r0, tos, tos, r0
    str r0, [psp]
    NEXT

@------------------------------------------------------------------------------
  CODEWORD Flag_visible, "m*", MSTAR
  @ Multiply signed 32*32 = 64
  @ ( n n -- d )
@------------------------------------------------------------------------------
    ldr r0, [psp]
    smull r0, tos, tos, r0
    str r0, [psp]
    NEXT

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

3: 
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
  bl d_slash_mod
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
  NEXT
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
