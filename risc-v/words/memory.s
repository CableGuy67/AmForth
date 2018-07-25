# Memory access

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "move",MOVE  # Move some bytes around. This can cope with overlapping memory areas.
move:  # ( Quelladdr Zieladdr Byteanzahl -- ) ( Source Destination Count -- )
# -----------------------------------------------------------------------------
  push_x1_x10_x11

  popdadouble x10, x11

  # Count > 0 ?
  beq x10, zero, 3f # Nothing to do if count is zero.

  # Compare source and destination address to find out which direction to copy.
  beq x11, x3, 3f # If source and destionation are the same, nothing to do.
  bltu x13, x3, 2f
  
  addi x3, x3, -1
  addi x2, x11, -1

1:# Source > Destination --> Backward move
  add x5, x3, x10
  lbu x5, 0(x5)
  
  add x6, x11, x10
  sb x5, 0(x6)
  
  addi x10, x10, -1
  bne x10, zero, 1b
  j 3f

2:# Source < Destination --> Forward move
  lbu x5, 0(x3)
  sb x5, 0(x11)
  
  addi x3, x3, 1
  addi x11, x11, 1
  addi x10, x10, -1
  bne x10, zero, 2b

3:
  lw x3, 0(x4)
  addi x4, x4, 4

  pop_x1_x10_x11
  NEXT


# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "fill", FILL  # Fill memory with given byte.
  # ( Destination Count Filling -- )
# -----------------------------------------------------------------------------
  # 6.1.1540 FILL CORE ( c-addr u char -- ) If u is greater than zero, store char in each of u consecutive characters of memory beginning at c-addr.

  push_x10_x11

  popdadouble x10, x11
  #popda x10 # Filling byte
  #popda x11 # Count
  # TOS       Destination

  beq x11, zero, 2f

1:addi x11, x11, -1
  add x5, x3, x11
  sb x10, 0(x5)
  bne x11, zero, 1b

2:
  lw x3, 0(x4)
  addi x4, x4, 4

  pop_x10_x11
  NEXT


# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "+!", PLUSSTORE # ( x 32-addr -- )
                               # Adds 'x' to the memory cell at 'addr'.
# -----------------------------------------------------------------------------
  lw x5, 0(x4)
    lw x6, 0(x3)
    add x5, x5, x6
    sw x5, 0(x3)
  lw x3, 4(x4)
  addi x4, x4, 8
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "c@", CFETCH # ( 8-addr -- x )
                              # Loads the byte at 'addr'.
# -----------------------------------------------------------------------------
  lbu x3, 0(x3)
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "c!", CSTORE # ( x 8-addr -- )
# Given a value 'x' and an 8-bit-aligned address 'addr', stores 'x' to memory at 'addr', consuming both.
# -----------------------------------------------------------------------------
  lw x5, 0(x4)
  sb x5, 0(x3)
  lw x3, 4(x4)
  addi x4, x4, 8
  NEXT
