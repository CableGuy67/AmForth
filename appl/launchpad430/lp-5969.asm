
.include "preamble.inc"

APPUSERSIZE equ 10        ; bytes, see uinit.asm
RSTACK_SIZE equ 40        ; cells
PSTACK_SIZE equ 40        ; cells
; following only required for terminal tasks
TIB_SIZE  equ 92          ; bytes (must be even)

F_CPU EQU 8000000
AMFORTH_START equ 0e000h

; now include all and everything

.include "amforth.asm"
