
.msp430

.include "ram.inc"

.org AMFORTH_START         ; start address of Forth kernel

DONEXT:
        MOV @IP+,W      ; fetch word address into W
        MOV @W+,PC      ; fetch code address into PC, W=PFA

.include "drivers.asm"     ; 

.include "itc430core.asm"   ; code primitives
.include "itc430hilvl.asm"

; now include application specific parts
.include "dict_appl.inc"

; ----------------------------------------------------------------------
; END OF FORTH KERNEL

.set lastword = link           ; last word in dictionary
.set lastenv  = envlink

        END
