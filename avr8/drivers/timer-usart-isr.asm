;;; combined usart/timer interrupt

.dseg
ram_jiffies: .byte 2
.cseg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
XT_ISR_TIMER: .dw usart_timer_isr ; it is a code word called from forth vm
usart_timer_isr:
  push xl
  push xh

  lds zl, low(ram_jiffies)
  lds zh, high(ram_jiffies)
  ldd xl, Z+0
  ldd xh, Z+1
  adiw xl, 1
  std Z+0, xl
  std Z+1, xh
  call_ usart_rx_buffer
  pop xh
  pop xl
  jmp_ DO_NEXT

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
  ; setup the timer isr
  .dw XT_DOLITERAL,XT_ISR_TIMER
  .dw XT_DOLITERAL,TIMER_INT
  .dw XT_INTSTORE

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
