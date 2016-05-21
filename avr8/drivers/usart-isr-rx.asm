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
usart_rx_isr:
  push xl
  in xl, SREG
  push xl
  push xh
  push zl
  push zh

  call_ usart_rx_buffer

  pop zh
  pop zl
  pop xh
  pop xl
  out SREG, xl
  pop xl
  reti

.set usartpc = pc
.org URXCaddr
  jmp_ usart_rx_isr
.org usartpc
