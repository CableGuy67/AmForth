

.syntax unified
.cpu cortex-m4
.thumb
.equ m0core, 0

.text

.equ RamStart, 0x20000000
.equ RamEnd,   0x20008000

.equ FlashStart,  0x00004000
.equ FlashEnd,    0x00040000

.equ datastack_size, 128   
.equ returnstack_size, 128 
.equ refill_buf_size, 96
.equ appl_userarea_size, 8 

.include "amforth.s"
