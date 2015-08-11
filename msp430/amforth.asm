
.msp430

.include "itc430.inc"       ; registers, macros, and header structure
.include "ram.inc"          ; RAM Leyout
.include "vecs.asm" ; note: sets .org for vector tables

.org AMFORTH_START         ; start address of Forth kernel

.include "init.asm"
.include "itc430core.asm"   ; code primitives
.include "itc430hilvl.asm"


; now include application specific parts
.include "dict_appl.inc"

; ----------------------------------------------------------------------
; END OF FORTH KERNEL

.set lastword = link           ; last word in dictionary
.set lastenv  = envlink

        END
