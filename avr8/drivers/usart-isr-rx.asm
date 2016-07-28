;;; usart driver, receiving

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; forth code:
; : rx-isr usart-rx-buffer ;
;
; setup with
; ' rx-isr URXCaddr int!

XT_ISR_RX:
    .dw usart_rx_isr
usart_rx_isr:
  call_ usart_rx_buffer
  jmp_ DO_NEXT
