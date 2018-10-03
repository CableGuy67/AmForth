@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "and",AND @ ( x1 x2 -- x1&x2 )
                        @ Combines the top two stack elements using bitwise AND.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  ands tos, r0
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "or",OR @ ( x1 x2 -- x1|x2 )
                       @ Combines the top two stack elements using bitwise OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  orrs tos, r0
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "xor",XOR @ ( x1 x2 -- x1|x2 )
                        @ Combines the top two stack elements using bitwise exclusive-OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  eors tos, r0
  NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "not",NOT @ ( x -- ~x )
@ -----------------------------------------------------------------------------
  mvns tos, tos
NEXT

CODEWORD Flag_visible, "invert", INVERT
  mvns tos,tos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "rshift",RSHIFT @ ( x n -- x )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  lsrs r0, tos
  movs tos, r0
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "lshift",LSHIFT @ ( x n -- x )
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  lsls r0, tos
  movs tos, r0
NEXT
