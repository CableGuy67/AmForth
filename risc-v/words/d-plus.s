.macro addc dest, sour1, sour2
  add x7, \sour1, \sour2
  sltu x8, x7, \sour1
  add \dest, x7, x5
  sltu x9, \dest, x7
  or x5, x8, x9
.endm


#------------------------------------------------------------------------------
  CODEWORD "d+",DPLUS # ( 1L 1H 2L 2H )
dplus:
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

  addc x3,  x3,  x12
  addc x11, x11, x13

  pushda x11

  pop x13
  pop x12
  pop x11

  pop x9
  pop x8
  pop x7

  NEXT
