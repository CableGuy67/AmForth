@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "compare",COMPARE  @ Vergleicht zwei Strings  Compare two strings
@ -----------------------------------------------------------------------------
  bl compare
  mvns tos,tos
NEXT

compare:
  push {r0, r1, r2, r3, lr}

  popda r1        @ Length of second string
  ldm psp!, {r0}  @ Length of first  string
  cmp r0, r1
  beq 1f

    ldm psp!, {tos}
    movs tos, #0
    pop {r0, r1, r2, r3, pc}

1: @ Lengths are equal. Compare characters.
   ldm psp!, {r1}  @ Address of first string.
                   @ TOS contains address of second string.

   @ How many characters to compare left ?
2: cmp r0, #0
   beq 3f

     subs r0, #1
     ldrb r2, [r1, r0]
     ldrb r3, [tos, r0]

     cmp r2, r3
     beq 2b

     @ Unequal
     movs tos, #0
     pop {r0, r1, r2, r3, pc}

3: @ Equal !
   movs tos, #0
   mvns tos, tos
   pop {r0, r1, r2, r3, pc}

