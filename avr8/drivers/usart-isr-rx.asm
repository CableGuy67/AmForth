;;; usart driver, receiving

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; forth code:
; : rx-isr USART_DATA c@
;    usart_rx_data usart_rx_in c@ dup >r
;    + !
;    r> 1+ usart_rx_mask and usart_rx_in c!
; ;
; setup with
; ' rx-isr URXCaddr int!

XT_ISR_RX:
    .dw usart_rx_isr
usart_rx_isr:
  push xl
  push xh
  call_ usart_rx_buffer
  pop xh
  pop xl
  jmp_ DO_NEXT
