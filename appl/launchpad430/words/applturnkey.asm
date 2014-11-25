; ( -- ) System
; R( -- )
; application specific turnkey action

.if cpu_msp430==1
    HEADER(XT_APPLTURNKEY,11,"applturnkey",DOCOLON)
.endif

.if cpu_avr8==1
VE_APPLTURNKEY:
    .dw $ff0b
    .db "applturnkey",0
    .dw VE_HEAD
    .set VE_HEAD = VE_APPLTURNKEY
XT_APPLTURNKEY:
    .dw DO_COLON
PFA_APPLTURNKEY:
    .dw XT_USART
    .dw XT_INTON
.endif
    .dw XT_DOT_VER
    .dw XT_SPACE
    .dw XT_F_CPU
    .dw XT_DOLITERAL
    .dw 1000
    .dw XT_UMSLASHMOD
    .dw XT_SWAP
    .dw XT_DROP
    .dw XT_DECIMAL
    .dw XT_DOT
    .dw XISQUOTE
    .db 4
    .db "kHz "
    .align 16
    .dw XT_ITYPE

    .dw XT_CR
    .dw XT_TSTAMPINFO
    .dw XT_SPACE
    .dw XT_GITINFO
;    .dw XT_CR,XT_WORDS
    .dw XT_EXIT
