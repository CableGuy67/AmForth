;;; usart driver, receiving

; sizes have to be powers of 2!
.equ usart_rx_size = $10
.equ usart_rx_mask = usart_rx_size - 1
.dseg
usart_rx_data: .byte usart_rx_size+2
usart_rx_in: .byte 1
             .byte 1
usart_rx_out: .byte 1
              .byte 1

.cseg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; forth code:
; : rx-buffer USART_DATA c@
;    usart_rx_data usart_rx_in c@ dup >r
;    + !
;    r> 1+ usart_rx_mask and usart_rx_in c!
; ;
; setup with
; ' rx-isr URXCaddr int!
usart_rx_buffer:
  lds xh, USART_DATA
  ; optional: check for certain character(s) (e.g. CTRL-C)
  ; and trigger a soft interrupt instead of storing the
  ; charater into the input queue.
  cpi xh, 3
  brne usart_rx_store
  jmp 0
usart_rx_store:
  lds xl, usart_rx_in
  ldi zl, low(usart_rx_data)
  ldi zh, high(usart_rx_data)
  add zl, xl
  adc zh, zeroh
  st Z, xh

  inc xl
  andi xl,usart_rx_mask

  sts usart_rx_in, xl

usart_rx_finish:
  ret

; ( -- ) Hardware Access
; R( --)
; initialize usart
;VE_USART_INIT_RXBUFFER:
;  .dw $ff0x
;  .db "+usart-buffer"
;  .dw VE_HEAD
;  .set VE_HEAD = VE_USART_INIT_RXBUFFER
XT_USART_INIT_RX_BUFFER:
  .dw DO_COLON
PFA_USART_INIT_RX_BUFFER:          ; ( -- )
  .dw XT_DOLITERAL
  .dw usart_rx_data
  .dw XT_DOLITERAL
  .dw usart_rx_size + 6
  .dw XT_ZERO
  .dw XT_FILL
  .dw XT_EXIT

; ( -- c)
; MCU
; get 1 character from input queue, wait if needed using interrupt driver
VE_RX_BUFFER:
    .dw $ff06
    .db "rx-buf"
    .dw VE_HEAD
    .set VE_HEAD = VE_RX_BUFFER
XT_RX_BUFFER:
    .dw DO_COLON
PFA_RX_BUFFER:
  .dw XT_RXQ_BUFFER
  .dw XT_DOCONDBRANCH
  .dw PFA_RX_BUFFER
  .dw XT_DOLITERAL
  .dw usart_rx_out
  .dw XT_CFETCH
  .dw XT_DUP
  .dw XT_DOLITERAL
  .dw usart_rx_data
  .dw XT_PLUS
  .dw XT_CFETCH
  .dw XT_SWAP
  .dw XT_1PLUS
  .dw XT_DOLITERAL
  .dw usart_rx_mask
  .dw XT_AND
  .dw XT_DOLITERAL
  .dw usart_rx_out
  .dw XT_CSTORE
  .dw XT_EXIT

; ( -- f)  
; MCU
; check if unread characters are in the input queue using interrupt driver
VE_RXQ_BUFFER:
    .dw $ff07
    .db "rx?-buf",0
    .dw VE_HEAD
    .set VE_HEAD = VE_RXQ_BUFFER
XT_RXQ_BUFFER:
    .dw DO_COLON
PFA_RXQ_BUFFER:
  .dw XT_PAUSE
  .dw XT_DOLITERAL
  .dw usart_rx_out
  .dw XT_CFETCH
  .dw XT_DOLITERAL
  .dw usart_rx_in
  .dw XT_CFETCH
  .dw XT_NOTEQUAL
  .dw XT_EXIT
