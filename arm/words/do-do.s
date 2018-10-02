HEADLESS DODO
 @ save loopsys
 push {rloopindex, rlooplimit}

 @ create new loopsys from stack
 mov rloopindex, tos
 loadtos
 mov rlooplimit, tos
 loadtos

 add FORTHIP, #4
NEXT
