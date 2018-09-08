  CODEWORD Flag_visible, "!", STORE # ( x 32-addr -- )
  lw x5, 0(x4)
  sw x5, 0(x3)
  lw x3, 4(x4)
  addi x4, x4, 8
  NEXT
