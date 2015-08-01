; device specific 
.include "msp430g2553.inc"  ; MCU-specific register equates

RAMSTART equ 0200h
INFOFLASHSTART equ 1000h
INFOSTART  equ 01000h
INFOEND    equ 010BFh     ; do not allow config flash to be erased
FLASHSTART equ 0C000h
FLASHEND   equ 0DFFFh
MAINSEG    equ 512
INFOSEG    equ 64
INFO_SIZE  equ 128    ; bytes
