@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-key", SERIAL_KEY
@ -----------------------------------------------------------------------------

   ldr r0, =UARTDR    @ Einkommendes Zeichen abholen
   stmdb psp!, {tos}  @ Platz auf dem Datenstack schaffen

   ldr tos, [r0]      @ Register lesen
   uxtb tos, tos      @ 8 Bits davon nehmen, Rest mit Nullen auffüllen.
  
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "serial-key?", SERIAL_KEYQ
@ -----------------------------------------------------------------------------
   savetos
   movs tos, #0
   ldr r0, =UARTFR
   ldr r1, [r0]
   ands r1, #RXFE
   bne 1f
     mvns tos, tos
1: 
NEXT
