
CODEWORD "stdout", SERIAL_EMIT
  push {r7}
 
  push {r6}
  
  movs r0, #1   @ File descriptor 1: STDOUT
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #4   @ Syscall 4: Write
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
  
  movs r0, #0   @ File descriptor 0: STDIN
  mov  r1, sp   @ Pointer to Message
  movs r2, #1   @ 1 Byte
  movs r7, #3   @ Syscall 3: Read
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

CODEWORD "bye", BYE
  movs r0, tos @ Error code 
  movs r7, #1  @ Syscall 1: Exit
  swi #0
NEXT

VARIABLE "argv", ARGV

ramallot UNAME_BUF, 1024

CODEWORD "uname", UNAME
  savetos
  push {r7}

  ldr r0, =RAM_lower_UNAME_BUF  @ Start address
  movs r1, #0
  movs r2, #0
  movs r3, #0
  movs r4, #0
  movs r5, #0
  movs r6, #0
  ldr r7, =#122  
  swi #0

  pop {r7}
  ldr tos, =RAM_lower_UNAME_BUF
NEXT

ENVIRONMENT "hostname", HOSTNAME
  .word XT_DOLITERAL,RAM_lower_UNAME_BUF+0x41, XT_COUNT0
.word XT_EXIT
