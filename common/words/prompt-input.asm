; ( -- )
; System
; send the READY prompt to the command line

.if cpu_msp430==1
    HEADLESS(XT_DEFAULT_PROMPTINPUT,DOCOLON)
.endif

.if cpu_avr8==1
;VE_PROMPTOK:
;    .dw $ff02
;    .db "ok"
;    .dw VE_HEAD
;    .set VE_HEAD = VE_PROMPTOK
XT_DEFAULT_PROMPTINPUT:
    .dw DO_COLON
PFA_DEFAULT_PROMPTINPUT:
.endif
    .dw XT_CR
    .dw XT_EXIT

; ------------------------

.if cpu_msp430==1
;    DEFER(XT_PROMPTOK,2,"ok")
        DW      link
        DB      0FFh
.set link = $
        DB      6,".","input"
        .align 16
XT_PROMPTINPUT:
        DW      DODEFER
.endif

.if cpu_avr8==1
VE_PROMPTINPUT:
    .dw $FF06
    .db ".input"
    .dw VE_HEAD
    .set VE_HEAD = VE_PROMPTINPUT
XT_PROMPTINPUT:
    .dw PFA_DODEFER1
PFA_PROMPTINPUT:
.endif
    .dw USER_P_INPUT
    .dw XT_UDEFERFETCH
    .dw XT_UDEFERSTORE
