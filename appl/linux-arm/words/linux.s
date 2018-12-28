
CODEWORD "stdout", SERIAL_EMIT
  push {r7}
 
  push {r6}
  
  mov  r0, #1   @ File descriptor 1: STDOUT
  mov  r1, sp   @ Pointer to Message
  mov  r2, #1   @ 1 Byte
  mov  r7, #4   @ Syscall 4: Write
  swi #0
  
  pop {r6}
 
  pop {r7}
  loadtos

NEXT

COLON "stdout?", SERIAL_EMITQ
   .word XT_TRUE, XT_EXIT

CODEWORD "stdin", SERIAL_KEY
  savetos
  mov tos, #0
  push {r7}
 
  push {r6}
  
  mov  r0, #0   @ File descriptor 0: STDIN
  mov  r1, sp   @ Pointer to Message
  mov  r2, #1   @ 1 Byte
  mov  r7, #3   @ Syscall 3: Read
  swi #0
  
  cmp r0, #0 @ A size of zero bytes or less denotes EOF.
  ble.n PFA_BYE

  pop {r6}
  
  pop {r7}
  
  cmp tos, #4 @ Ctrl-D
  beq.n PFA_BYE
NEXT


COLON "stdin?", SERIAL_KEYQ
   .word XT_TRUE, XT_EXIT

CODEWORD "std-init", UART_INIT
NEXT


CODEWORD "syscall", SYSCALL @ ( r0 r1 r2 r3 r4 r5 Syscall# -- r0 )

 mov r7, tos
 ldr r5, [psp], #4
 ldr r4, [psp], #4
 ldr r3, [psp], #4
 ldr r2, [psp], #4
 ldr r1, [psp], #4
 ldr r0, [psp], #4

 swi #0

 mov tos, r0 @ Syscall reply into TOS
NEXT

CODEWORD "cacheflush", CACHEFLUSH @ ( -- )
@ -----------------------------------------------------------------------------
  push {r6, r7}

  dmb
  dsb
  isb  
  
  ldr r0, =CACHESTART  @ Start address
  ldr r1, =CACHEEND    @ End  address
  movs r2, #0          @ This zero is important !s
  movs r3, #0
  movs r4, #0
  movs r5, #0
  movs r6, #0
  ldr r7, =0x000f0002  @ Syscall __ARM_NR_cacheflush
  swi #0

  pop {r6, r7}
NEXT

CODEWORD "bye", BYE
  mov  r0, tos @ Error code 
  mov  r7, #1  @ Syscall 1: Exit
  swi #0
NEXT

VARIABLE "argv", ARGV

ramallot UNAME_BUF, 512

CODEWORD "uname", UNAME
  savetos
  push {r7}

  ldr r0, =RAM_lower_UNAME_BUF  @ Start address
  mov r1, #0
  mov r2, #0
  mov r3, #0
  mov r4, #0
  mov r5, #0
  mov r6, #0
  ldr r7, =#122  
  swi #0

  pop {r7}
  loadtos
NEXT

ENVIRONMENT "hostname", HOSTNAME
  .word XT_DOLITERAL,RAM_lower_UNAME_BUF+0x41, XT_COUNT0
.word XT_EXIT
