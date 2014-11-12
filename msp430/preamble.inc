; generic macros and register definitions
.include "macros.asm"

; controller specific file selected via include
; directory definition when calling the assembler (-I)
.include "device.asm"

; some defaults, change them in your application master file
; see template.asm for an example

AMFORTH_RO_SEG equ NRWW_START_ADDR

; receiving is asynchron, so an interrupt queue is useful.
WANT_ISR_RX equ 1

; case insensitve dictionary lookup.
WANT_IGNORECASE equ 0

; map all memories to one address space. Details in the
; technical guide
WANT_UNIFIED equ 0

; terminal input buffer
TIBSIZE equ $64    ; ANS94 needs at least 80 characters per line

; USER variables *in addition* to system ones
APPUSERSIZE equ 10  ; size of application specific user area in bytes

; addresses of various data segments
rstackstart equ RAMEND      ; start address of return stack, grows downward
stackstart  equ RAMEND - 80 ; start address of data stack, grows downward
; change only if you know what to you do
NUMWORDLISTS equ 8 ; number of word lists in the searh order, at least 8
NUMRECOGNIZERS equ 4 ; total number of recognizers, two are always used.

; 10 per mille (1 per cent) is ok.
BAUD equ 38400
BAUD_MAXERROR equ 10

; Dictionary setup
.set VE_HEAD = 0000
.set VE_ENVHEAD = 0000
.set ESEGPTR = 0
