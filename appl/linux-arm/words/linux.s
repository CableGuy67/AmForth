
CODEWORD "stdout", SERIAL_EMIT
  push {r0, r1, r2, r3, r4, r5, r7}
 
  push {r6}
  
  movs r0, #1   @ File descriptor 1: STDOUT
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #4   @ Syscall 4: Write
  swi #0
  
  pop {r6}
 
  pop {r0, r1, r2, r3, r4, r5, r7}
  loadtos

NEXT

COLON "stdout?", SERIAL_EMITQ
   .word XT_TRUE, XT_EXIT

CODEWORD "stdin", SERIAL_KEY
  savetos
  mov tos, #0
  push {r0, r1, r2, r3, r4, r5, r7}
 
  push {r6}
  
  movs r0, #0   @ File descriptor 0: STDIN
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #3   @ Syscall 3: Read
  swi #0
  
  cmp r0, #0 @ A size of zero bytes or less denotes EOF.
  ble.n PFA_BYE

  pop {r6}
  
  pop {r0, r1, r2, r3, r4, r5, r7}
  
  cmp tos, #4 @ Ctrl-D
  beq.n PFA_BYE
NEXT


COLON "stdin?", SERIAL_KEYQ
   .word XT_TRUE, XT_EXIT

CODEWORD "std-init", UART_INIT
NEXT


CODEWORD "syscall", SYSCALL @ ( r0 r1 r2 r3 r4 r5 r6 Syscall# -- r0 )
 push {r4, r5, r7} @ Save registers !

 push {r6} @ Syscall number

 ldm psp!, {r6}
 ldm psp!, {r5}
 ldm psp!, {r4}
 ldm psp!, {r3}
 ldm psp!, {r2}
 ldm psp!, {r1}
 ldm psp!, {r0}

 pop {r7} @ into r7

 swi #0

 pop {r4, r5, r7}

 adds r7, #28 @ Drop 7 elements at once
 movs r6, r0 @ Syscall reply into TOS
 
NEXT

CODEWORD "cacheflush", CACHEFLUSH @ ( -- )
  push {r4, r5, r6, r7}

  dmb
  dsb
  isb  
  
  ldr r0, =FlashStart  @ Start address
  ldr r1, =RamEnd      @ End  address
  movs r2, #0          @ This zero is important !s
  movs r3, #0
  movs r4, #0
  movs r5, #0
  movs r6, #0
  ldr r7, =0x000f0002  @ Syscall __ARM_NR_cacheflush
  swi #0

  pop {r4, r5, r6, r7}
NEXT

CODEWORD "bye", BYE
  movs r0, tos @ Error code 
  movs r7, #1  @ Syscall 1: Exit
  swi #0
NEXT
