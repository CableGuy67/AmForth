; for a description, what can be done in this
; file see ../template/template.asm. You may want to
; copy that file to this one and edit it afterwards.







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
.include "devices/atmega328p/words/sleep.asm"	

.include "amforth.asm"


