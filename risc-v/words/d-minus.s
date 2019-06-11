.macro subc dest, sour1, sour2
  sub x7, \sour1, \sour2
  sltu x8, \sour1, \sour2
  sub \dest, x7, x5
  sltu x9, x7, x5
  or x5, x8, x9
.endm

#------------------------------------------------------------------------------
  CODEWORD  "d-", DMINUS # ( 1L 1H 2L 2H )
#------------------------------------------------------------------------------
  push x10

  lw x5, 8(x4)
  lw x6, 0(x4)

  sub x10, x5, x6
  sw x10, 8(x4)

  sltu x10, x5, x6

  lw x5, 4(x4)
  sub x3, x5, x3
  sub x3, x3, x10

  addi x4, x4, 8

  pop x10

  NEXT
