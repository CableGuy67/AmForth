; ( "<spaces>name" -- c ) 
; Tools
; copy the first character of the next word onto the stack

.if cpu_msp430==1
    HEADER(XT_CHAR,4,"char",DOCOLON)
.endif

.if cpu_avr8==1
VE_CHAR:
    .dw $ff04
    .db "char"
    .dw VE_HEAD
    .set VE_HEAD = VE_CHAR
XT_CHAR:
    .dw DO_COLON
PFA_CHAR:
.endif
    .dw XT_PARSENAME
    .dw XT_ZEROEQUAL,XT_DOCONDBRANCH 
    DEST(CHAR_1)
       .dw XT_DOLITERAL, -16, XT_THROW
CHAR_1:

    .dw XT_CFETCH
    .dw XT_EXIT
