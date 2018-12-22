
.syntax unified

.equ datastack_size, 128   
.equ returnstack_size, 128 
.equ refill_buf_size, 96
.equ appl_userarea_size, 8 
.equ leavestack_size, 8*4


.section amforth, "awx" @ Everything is writeable and executable
.align 4

.global _start
_start:
  ldr r0, =PFA_COLD+1
  bx r0 @ Switch to thumb mode

.thumb

.include "macros.s"

.include "preamble.inc"
.include "user.inc"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

ENDDICT

.bss

@ Dataspace

.equ RamStart, .
  .rept 1024 * 256      @ 1024 * 254*4 = 1 MB for RAM dictionary
  .word 0x00000000
  .endr
.equ RamEnd, .

.equ FlashStart, .
  .rept 1024 * 256      @ 1024 * 254*4 = 1 MB for RAM dictionary
  .word 0x00000000
  .endr
.equ FlashEnd, .
