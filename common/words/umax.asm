
VE_UMAX:
    .dw $ff04
    .db "umax"
    .dw VE_HEAD
    .set VE_HEAD = VE_UMAX
XT_UMAX:
    .dw DO_COLON
PFA_UMAX:

        .DW XT_2DUP,XT_ULESS,
	.dw XT_DOCONDBRANCH
	 DEST(UMAX1)
        .DW XT_SWAP
UMAX1:  .DW XT_DROP
	.dw XT_EXIT
