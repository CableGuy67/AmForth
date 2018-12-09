HEADLESS DODO
 @ save loopsys
 push {rloopindex, rlooplimit}

 @ create new loopsys from stack
 mov rloopindex, tos
 loadtos
 mov rlooplimit, tos
 loadtos

 add rlooplimit, #0x80000000
 sub rloopindex, rlooplimit
NEXT
