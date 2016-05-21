;;; combined usart/timer interrupt

.set pc_ = pc
.org TIMER_INT
  jmp_ usart_timer_isr
.org pc_

.dseg
ram_jiffies: .byte 2
.cseg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
usart_timer_isr:
  push xl
  in xl, SREG
  push xl
  push xh
  push zl
  push zh

  lds zl, low(ram_jiffies)
  lds zh, high(ram_jiffies)
  ldd xl, Z+0
  ldd xh, Z+1
  adiw xl, 1
  std Z+0, xl
  std Z+1, xh
  call_ usart_rx_buffer
  pop zh
  pop zl
  pop xh
  pop xl
  out SREG, xl
  pop xl
  reti

; ( -- ) Hardware Access
; R( --)
; initialize usart
;VE_USART_INIT_RX:
;  .dw $ff06
;  .db "+usart"
;  .dw VE_HEAD
;  .set VE_HEAD = VE_USART_INIT_RX
XT_USART_INIT_RX_ISR:
  .dw DO_COLON
PFA_USART_INIT_RX_ISR:          ; ( -- )
  .dw XT_ZERO
  .dw XT_JIFFIES
  .dw XT_STORE
  .dw XT_ZERO
  .dw XT_DOLITERAL
  .dw usart_rx_in
  .dw XT_STORE

  .dw XT_EXIT

; ( -- addr ) 
; System Variable
; Timer Jiffies
VE_JIFFIES:
    .dw $ff07
    .db "jiffies",0
    .dw VE_HEAD
    .set VE_HEAD = VE_JIFFIES
XT_JIFFIES:
    .dw PFA_DOVARIABLE
PFA_JIFFIES:
    .dw ram_jiffies
