; ( -- ) System
; R( -- )
; GIT Info

.if cpu_msp430==1
    HEADER(XT_GITINFO,8,"git-info",DOCOLON)
    .dw XISQUOTE
    .db 68
.endif

.if cpu_avr8==1
VE_GITINFO:
    .dw $ff08
    .db "git-info"
    .dw VE_HEAD
    .set VE_HEAD = VE_GITINFO
XT_GITINFO:
    .dw DO_COLON
PFA_GITINFO:
    .dw XT_DOSLITERAL
    .dw 68
.endif
    .db "fatal: Not a git repository (or any of the parent directories): .git"
.if cpu_msp430==1
    .align 16
.endif
    .dw XT_ITYPE
    .dw XT_EXIT
