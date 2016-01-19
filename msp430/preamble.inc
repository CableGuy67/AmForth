
.set NUMWORDLISTS = 8

.include "macros.asm"       ; registers, macros, and header structure

.include "device.asm"
.include "compat.inc"
.include "user.inc"

.org AMFORTH_START         ; start address of Forth kernel
