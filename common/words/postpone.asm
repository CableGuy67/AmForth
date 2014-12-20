; ( "<space>name" --  )
; Compiler
; Append the compilation semantics of "name" to the dictionary

.if cpu_msp430==1
    HEADER(XT_POSTPONE,8,"postpone",DOCOLON)
.endif

.if cpu_avr8==1
VE_POSTPONE:
    .dw $0008
    .db "postpone"
    .dw VE_HEAD
    .set VE_HEAD = VE_POSTPONE
XT_POSTPONE:
    .dw DO_COLON
PFA_POSTPONE:
.endif
    .dw XT_PARSENAME
    .dw XT_DORECOGNIZER
    .dw XT_CELLPLUS ; skip to postpone action, beware, this is dangerous code
.if cpu_msp430==1
    .dw XT_CELLPLUS
.endif
    .dw XT_FETCHI
    .dw XT_EXECUTE
    .dw XT_EXIT
