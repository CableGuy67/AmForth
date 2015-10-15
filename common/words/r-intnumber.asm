; ( -- addr )
; Interpreter
; Method table for single cell integers
.if cpu_msp430==1
    HEADER(XT_R_NUM,5,"r:num",DOROM)
.endif

.if cpu_avr8==1
VE_R_NUM:
    .dw $ff05
    .db "r:num",0
    .dw VE_HEAD
    .set VE_HEAD = VE_R_NUM
XT_R_NUM:
    .dw PFA_DOCONSTANT
PFA_R_NUM:
.endif
    .dw XT_NOOP    ; interpret
    .dw XT_LITERAL ; compile
    .dw XT_LITERAL ; postpone

; ( -- addr )
; Interpreter
; Method table for double cell integers
.if cpu_msp430==1
    HEADER(XT_R_DNUM,6,"r:dnum",DOROM)
.endif

.if cpu_avr8==1
VE_R_DNUM:
    .dw $ff06
    .db "r:dnum"
    .dw VE_HEAD
    .set VE_HEAD = VE_R_DNUM
XT_R_DNUM:
    .dw PFA_DOCONSTANT
PFA_R_DNUM:
.endif
    .dw XT_NOOP     ; interpret
    .dw XT_2LITERAL ; compile
    .dw XT_2LITERAL ; postpone

; ( addr len -- f )
; Interpreter
; recognizer for integer numbers
.if cpu_msp430==1
    HEADER(XT_REC_NUM,7,"rec:num",DOCOLON)
.endif

.if cpu_avr8==1

VE_REC_NUM:
    .dw $ff07
    .db "rec:num",0
    .dw VE_HEAD
    .set VE_HEAD = VE_REC_NUM
XT_REC_NUM:
    .dw DO_COLON
PFA_REC_NUM:
.endif
    ; try converting to a number
    .dw XT_NUMBER
    .dw XT_DOCONDBRANCH
    DEST(PFA_REC_NONUMBER)
    .dw XT_ONE
    .dw XT_EQUAL
    .dw XT_DOCONDBRANCH
    DEST(PFA_REC_INTNUM2)
      .dw XT_R_NUM
      .dw XT_EXIT
PFA_REC_INTNUM2:
      .dw XT_R_DNUM
      .dw XT_EXIT
PFA_REC_NONUMBER:
    .dw XT_R_FAIL
    .dw XT_EXIT
