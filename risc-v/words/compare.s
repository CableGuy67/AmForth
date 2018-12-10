# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "compare",COMPARE
# -----------------------------------------------------------------------------

.if WANT_IGNORECASE==1
.macro lowercase Register # Convert to lowercase.
  #    Hex Dec  Hex Dec
  # A  41  65   61  97  a
  # Z  5A  90   7A  122 z
  
  sltiu x14, \Register, 0x41
  bne x14, zero, 5f
    sltiu x14, \Register, 0x5B
    beq x14, zero, 5f
      addi \Register, \Register, 0x20    
5:
.endm
.endif

  mv x10, x3
  lw x11, 0(x4)
  lw x12, 4(x4)
  lw x3, 8(x4)
  addi x4, x4, 12

  beq x10, x12, 2f
    # Lengths not equal.
1:  li x3, -1
    j 4f

  # Lengths are equal. Compare characters.
  
2:beq x10, zero, 3f    # Any characters to compare left ?

  lbu x12, 0(x11)
.if WANT_IGNORECASE==1
  lowercase x12
.endif
  lbu x13, 0(x3)
.if WANT_IGNORECASE==1
  lowercase x13
.endif
  bne x12, x13, 1b
  
  addi x10, x10, -1
  addi x11, x11, 1
  addi x3,  x3,  1
  j 2b
  
3: mv x3, zero

4:
  NEXT
