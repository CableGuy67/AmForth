
CODEWORDS Flags_visible,"execute",EXECUTE

  lw x6,x3
  lw x3, 0(x4)
  addi x4, x4, 4
  j DO_EXECUTE
