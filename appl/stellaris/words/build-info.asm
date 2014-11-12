; ( -- ) System
; R( -- )
; GIT Info

.if cpu_msp430==1
    HEADER(XT_TSTAMPINFO,10,"build-info",DOCOLON)
    .dw XISQUOTE
    .db 20
.endif

.if cpu_avr8==1
VE_TSTAMPINFO:
    .dw $ff0a
    .db "build-info"
    .dw VE_HEAD
    .set VE_HEAD = VE_TIMEINFO
XT_TIMEINFO:
    .dw DO_COLON
PFA_GITINFO:
    .dw XT_DOSLITERAL
    .dw 20
.endif
    .db "12.Nov.2014 20:37:55"
.if cpu_msp430==1
    .align 16
.endif
    .dw XT_ITYPE
    .dw XT_EXIT
