; the 256x devices are special since they *require*
; both a 24bit address space and they need a special
; flash store placement in the NRWW section, way outside
; of the standard 16bit jump distance.

; note that dict_appl_core includes a store-i_big.asm
; instead if the normal store-i.asm file. This file
; has all the magic needed for the large address space.
; *everything else* is identical to other controllers.

.include "preamble.inc"

; cpu clock in hertz
.equ F_CPU = 16000000
.set BAUD = 38400
.set BAUD_MAXERROR=10

.include "drivers/usart_0.asm"

.include "words/reg-a.asm"	
.include "words/reg-b.asm"

.include "words/bm-set.asm"
.include "words/bm-clear.asm"
.include "words/bm-toggle.asm"

.include "words/spirw.asm"
.include "words/wdr.asm"
.include "words/store-wdc.asm"
.include "devices/atmega2560/words/sleep.asm"	
	
; all of amforth is in one segment
.include "amforth-low.asm"
