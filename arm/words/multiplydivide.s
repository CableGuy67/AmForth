@ -----------------------------------------------------------------------------
  COLON Flag_visible, "mod", MOD @ ( n1 n2 -- rem )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_NIP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  COLON Flag_visible, "/", SLASH @ ( n1 n2 -- n1/n2 )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_DROP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "*",STAR @ ( u1|n1 u2|n2 -- u3|n3 )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}    @ Get u1|n1 into a register.
  muls tos, r0      @ Multiply!
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible,"/mod",SLASHMOD @ ( n1 n2 -- rem quot )
  bl divmod
NEXT

divmod:                             @ ARM provides no remainder operation, so we fake it by un-dividing and subtracting.
@ -----------------------------------------------------------------------------
  .ifdef m0core

  push {lr}
  popda r0 @ Divisor
  @     TOS: Dividend

  cmp tos, #0 @ Prüfe den Dividenden
  bge.n divmod_plus
  rsbs tos, tos, #0

divmod_minus:
    cmp r0, #0
    bge.n divmod_minus_plus

divmod_minus_minus:
      rsbs r0, r0, #0
      pushda r0
      bl u_divmod
      popda r0
      rsbs tos, tos, #0
      pushda r0
      pop {pc}

divmod_minus_plus:
      pushda r0
      bl u_divmod
      popda r0
      rsbs r0, r0, #0
      rsbs tos, tos, #0
      pushda r0
      pop {pc}

divmod_plus:
    cmp r0, #0
    bge.n divmod_plus_plus

divmod_plus_minus:
      rsbs r0, r0, #0
      pushda r0
      bl u_divmod
      rsbs tos, tos, #0
      pop {pc}

divmod_plus_plus:
      pushda r0
      bl u_divmod
      pop {pc}

  .else
   push {lr}
  ldm psp!, {r0}       @ Get u1 into a register
  movs r1, tos       @ Back up the divisor in X.
  sdiv tos, r0, tos @ Divide: quotient in TOS.
  muls r1, tos, r1   @ Un-divide to compute remainder.
  subs r0, r1         @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  pop {pc}

  .endif

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "u/mod", USLASHMOD @ ( u1 u2 -- rem quot )

  bl u_divmod
NEXT

u_divmod:                            @ ARM provides no remainder operation, so we fake it by un-dividing and subtracting.
@ -----------------------------------------------------------------------------
  .ifdef m0core
  push {lr}
  popda r1
  @ Catch divide by zero..
  cmp r1, #0
  bne 1f          @ Alles ist Rest                
    savetos
    movs tos, #0
  pop {pc}
1:

  @ Shift left the denominator until it is greater than the numerator
  movs r2, #1    @ Zähler
  movs r3, #0    @ Ergebnis
  cmp tos, r1
  bls 3f
  adds r1, #0    @ Dont shift if denominator would overflow
  bmi 3f
	
2:lsls r2, #1
  lsls r1, #1
  bmi 3f
  cmp tos, r1
  bhi 2b

3:cmp tos, r1
  bcc 4f         @ if (num>denom)
  subs tos, r1     @ numerator -= denom
  orrs r3, r2      @ result(r3) |= bitmask(r2)

4:lsrs r1, #1    @ denom(r1) >>= 1
  lsrs r2, #1    @ bitmask(r2) >>= 1
  bne 3b

  pushda r3
  pop {pc}
  .else
  push {lr}
  ldm psp!, {r0}       @ Get u1 into a register
  movs r1, tos        @ Back up the divisor in X.
  udiv tos, r0, tos  @ Divide: quotient in TOS.
  muls r1, tos, r1    @ Un-divide to compute remainder.
  subs r0, r1          @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  pop {pc}
  .endif
