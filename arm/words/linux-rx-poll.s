
CODEWORD Flag_visible, "usart-rx", SERIAL_KEY
  savetos
  push {r7}
  movs r0, #0   @ File descriptor 0: STDIN
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #3   @ Syscall 3: Read
  swi #0
NEXT

COLON Flag_visible, "usart-rx?", SERIAL_KEYQ
  .word XT_TRUE
.word XT_EXIT


