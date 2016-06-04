
.msp430

.include "macros.asm"       ; registers, macros, and header structure
.include "ram.inc"          ; RAM Leyout
.include "vecs.asm" ; note: sets .org for vector tables

.org AMFORTH_START         ; start address of Forth kernel

.include "init.asm"
.include "drivers.asm"
.include "amforth-interpreter.asm"
.include "itc430core.asm"   ; code primitives
.include "itc430hilvl.asm"

; now include application specific parts
.include "dict_appl.inc"
