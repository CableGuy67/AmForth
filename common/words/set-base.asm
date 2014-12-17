; ( addr len -- addr' len' ) 
; Numeric IO
; skip a numeric prefix character

.if cpu_msp430==1
    HEADLESS(XT_SET_BASE,DOCOLON)
.endif

.if cpu_avr8==1
XT_SET_BASE:
    .dw DO_COLON 
PFA_SET_BASE:        ; ( adr1 len1 -- adr2 len2 ) 
.endif
    .dw XT_OVER 
    .dw XT_CFETCH 
    .dw XT_DUP 
    .dw XT_DOLITERAL
    .dw 36     ; '$' 
    .dw XT_EQUAL 
    .dw XT_DOCONDBRANCH
    DEST(PFA_SETBASE0)
    .dw XT_HEX
    .dw XT_DOBRANCH
    DEST(PFA_SETBASE_FOUND)
PFA_SETBASE0:
    .dw XT_DUP 
    .dw XT_DOLITERAL
    .dw 37 ; '%' 
    .dw XT_EQUAL 
    .dw XT_DOCONDBRANCH
    DEST(PFA_SETBASE1)
    .dw XT_BIN
    .dw XT_DOBRANCH
    DEST(PFA_SETBASE_FOUND)
PFA_SETBASE1:
    .dw XT_DUP 
    .dw XT_DOLITERAL
    .dw 38   ; '&'
    .dw XT_EQUAL 
    .dw XT_DOCONDBRANCH
    DEST(PFA_SETBASE2)
    .dw XT_DECIMAL 
    .dw XT_DOBRANCH
    DEST(PFA_SETBASE_FOUND)
PFA_SETBASE2:
    .dw XT_DUP
    .dw XT_DOLITERAL
    .dw 35 ; '#'
    .dw XT_EQUAL 
    .dw XT_DOCONDBRANCH
    DEST(PFA_SETBASE3)
    .dw XT_DECIMAL 
PFA_SETBASE_FOUND:
    .dw XT_DROP
    .dw XT_DOLITERAL
    .dw 1
    .dw XT_SLASHSTRING
    .dw XT_EXIT
PFA_SETBASE3:
    .dw XT_DROP
    .dw XT_EXIT 
