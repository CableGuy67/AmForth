; ( n -- )
; MCU
; timed write into watchdog control registers
VE_STORE_WDC:
    .dw $ff04
    .db "!wdc"
    .dw VE_HEAD
    .set VE_HEAD = VE_STORE_WDc
XT_STORE_WDC:
    .dw PFA_STORE_WDC
PFA_STORE_WDC:
     in temp1,SREG
     mov temp0, tosl    
     cli
     ; Reset Watchdog Timer
     wdr
     ; Clear WDRF in MCUSR
     in_ temp2, MCUSR
     andi temp2, (0xff & (0<<WDRF))
     out_ MCUSR, temp2

     in_ temp2, WDTCSR

     ori  temp2, (1<<WDCE) | (1<<WDE)

     out_ WDTCSR, temp2
     out_ WDTCSR, temp0
     loadtos
     out SREG,temp1
     jmp_ DO_NEXT
