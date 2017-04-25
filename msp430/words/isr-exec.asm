; ( n -- ) 
; Interrupt
; executes an interrupt service routine
 HEADLESS(XT_ISREXEC,DOCOLON)
    .dw XT_DOLITERAL
    .dw CFG_ISRVECS
    .dw XT_PLUS
    .dw XT_FETCH
    .dw XT_EXECUTE
    .dw XT_EXIT
