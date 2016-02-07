
.msp430

.include "ram.inc"

.org AMFORTH_START         ; start address of Forth kernel

.include "amforth-interpreter.asm"

.include "drivers.asm"     ; 

.include "dict.inc"       ; The system Dictionary
. include "dict_appl.inc" ; The application specific dictionary

; ----------------------------------------------------------------------
; END OF FORTH KERNEL

.set lastword = link           ; last word in dictionary
.set lastenv  = envlink

        END
