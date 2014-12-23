; convert a RAM address into an INFO flash address
; base a>info @ may be 0 or another value
 HEADER(XT_ADDR_TO_INFO,6,"a>info",DOCOLON)

  .dw XT_DOLITERAL, 1000h, U0,XT_MINUS,XT_PLUS,XT_EXIT
