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
  addi sp, sp, -12
  sw x7, 8(sp)
  sw x8, 4(sp)
  sw x9, 0(sp)
  
  popda x13 # 2H
  popda x12 # 2L
  popda x11 # 1H
            # 1L in x3

  li x5, 0 # Carry in

  subc x3,  x3,  x12
  subc x11, x11, x13

  pushda x11

  lw x9,0(sp)
  lw x8,4(sp)
  lw x7,8(sp)
  addi sp,sp,12

  NEXT
