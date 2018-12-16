@ -----------------------------------------------------------------------------
  COLON "mod", MOD @ ( n1 n2 -- rem )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_NIP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  COLON "/", SLASH @ ( n1 n2 -- n1/n2 )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_DROP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  CODEWORD "*",STAR @ ( u1|n1 u2|n2 -- u3|n3 )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}    @ Get u1|n1 into a register.
  muls tos, r0      @ Multiply!
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD "/mod",SLASHMOD @ ( n1 n2 -- rem quot )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}     @ Get u1 into a register
  movs r1, tos       @ Back up the divisor in X.
  sdiv tos, r0, tos  @ Divide: quotient in TOS.
  muls r1, tos, r1   @ Un-divide to compute remainder.
  subs r0, r1        @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  NEXT
@ -----------------------------------------------------------------------------
  CODEWORD "u/mod", USLASHMOD @ ( u1 u2 -- rem quot )
  ldm psp!, {r0}      @ Get u1 into a register
  movs r1, tos        @ Back up the divisor in X.
  udiv tos, r0, tos   @ Divide: quotient in TOS.
  muls r1, tos, r1    @ Un-divide to compute remainder.
  subs r0, r1         @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  NEXT
