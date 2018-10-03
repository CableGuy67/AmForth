@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "pick", PICK @ ( xu .. x1 x0 u -- xu ... x1 x0 xu ) 
@ -----------------------------------------------------------------------------
.ifdef m0core
  lsls r0, tos, #2
  ldr tos, [psp, r0]
.else
  ldr tos, [psp, tos, lsl #2]  
.endif
NEXT
