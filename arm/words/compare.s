@ -----------------------------------------------------------------------------
  CODEWORD "compare",COMPARE  @ Compare two strings
@ -----------------------------------------------------------------------------
  bl compare
  mvns tos,tos
NEXT

.if WANT_IGNORECASE==1
.macro lowercase Register @ Ein Zeichen in einem Register wird auf Lowercase umgestellt.
  @    Hex Dec  Hex Dec
  @ A  41  65   61  97  a
  @ Z  5A  90   7A  122 z
  cmp \Register, #0x41
  blo 5f
  cmp \Register, #0x5B
  it lo
  addlo \Register, #0x20
5:  
.endm
.endif

compare:
  push {lr}

  popda r1        @ Length of second string
  ldm psp!, {r0}  @ Length of first  string
  cmp r0, r1
  beq 1f

    ldm psp!, {tos}
    movs tos, #0
    pop {pc}

1: @ Lengths are equal. Compare characters.
   ldm psp!, {r1}  @ Address of first string.
                   @ TOS contains address of second string.

   @ How many characters to compare left ?
2: cmp r0, #0
   beq 3f

     subs r0, #1
     ldrb r2, [r1, r0]
     ldrb r3, [tos, r0]

.if WANT_IGNORECASE==1
     lowercase r2
     lowercase r3
.endif

     cmp r2, r3
     beq 2b

     @ Unequal
     movs tos, #0
     pop {pc}

3: @ Equal !
   movs tos, #0
   mvns tos, tos
   pop {pc}

