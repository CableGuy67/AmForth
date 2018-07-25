.macro subc dest, sour1, sour2
  sub x7, \sour1, \sour2
  sltu x8, \sour1, \sour2
  sub \dest, x7, x5
  sltu x9, x7, x5
  or x5, x8, x9
.endm

#------------------------------------------------------------------------------
  CODEWORD Flag_visible, "d-", DMINUS # ( 1L 1H 2L 2H )
dminus: # Carry out in x5.
#------------------------------------------------------------------------------
  push x7
  push x8
  push x9

  push x11
  push x12
  push x13

  popda x13 # 2H
  popda x12 # 2L
  popda x11 # 1H
            # 1L in x3

  li x5, 0 # Carry in

  subc x3,  x3,  x12
  subc x11, x11, x13

  pushda x11

  pop x13
  pop x12
  pop x11

  pop x9
  pop x8
  pop x7

  NEXT
