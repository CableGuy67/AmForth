
CODEWORD Flag_visible, "linux-emit", SERIAL_EMIT
    push {r7}
    movs r0, #1   @ File descriptor 1: STDOUT
    mov  r1, sp   @ Pointer to Message
    movs r2, #1   @ 1 Byte
    movs r7, #4   @ Syscall 4: Write

    swi     $0          /* invoke syscall */
    pop {r7}
    loadtos
NEXT

COLON Flag_visible, "linux-emit?", SERIAL_EMITQ
  .word XT_TRUE
.word XT_EXIT
