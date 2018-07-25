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
  addi sp, sp, -24
  sw x7, 20(sp)
  sw x8, 16(sp)
  sw x9, 12(sp)
  
  #push x7
  #push x8
  #push x9
  
  sw x11, 8(sp)
  sw x12, 4(sp)
  sw x13, 0(sp)
  #push x11
  #push x12
  #push x13

  popda x13 # 2H
  popda x12 # 2L
  popda x11 # 1H
            # 1L in x3

  li x5, 0 # Carry in

  subc x3,  x3,  x12
  subc x11, x11, x13

  pushda x11

  lw x13,0(sp)
  lw x12,4(sp)
  lw x11,8(sp)

  lw x9,12(sp)
  lw x8,16(sp)
  lw x7,20(sp)
  addi sp,sp,24

  NEXT
