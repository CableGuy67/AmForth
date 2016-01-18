
mcu_name:
	.db 12,"MSP430FR5969"
	.align 16

; ----------------------------------------------------------------------
; DEFAULT INTERRUPT HANDLER

nullirq: RETI
