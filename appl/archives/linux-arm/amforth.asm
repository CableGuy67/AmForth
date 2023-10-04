
.syntax unified

.equ datastack_size, 1024   
.equ returnstack_size, 1024
.equ refill_buf_size, 96
.equ appl_userarea_size, 8 
.equ leavestack_size, 128


.section amforth, "awx" @ Everything is writeable and executable
.align 4
.text
.global _start
_start:
  ldr r0, =PFA_ARGV  @ Save the initial stack pointer, as it contains
  str sp, [r0]       @ command line arguments. Do this only once on first entry.

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

.include "dict_appl.inc"

ENDDICT

.bss

.equ CACHESTART, .

.equ RamStart, .
  .rept 1024 * 256      @ 1024 * 254*4 = 1 MB for RAM dictionary
  .word 0x00000000
  .endr
.equ RamEnd, .

.equ CACHEEND, .
