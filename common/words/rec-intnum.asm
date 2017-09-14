; ( -- addr )
; Interpreter
; Method table for single cell integers
.if cpu_msp430==1
    HEADER(XT_RECTYPE_NUM,11,"rectype-num",DOROM)
.endif

.if cpu_avr8==1
VE_RECTYPE_NUM:
    .dw $ff0b
    .db "rectype-num",0
    .dw VE_HEAD
    .set VE_HEAD = VE_RECTYPE_NUM
XT_RECTYPE_NUM:
    .dw PFA_DOCONSTANT
PFA_RECTYPE_NUM:
.endif
    .dw XT_NOOP    ; interpret
    .dw XT_LITERAL ; compile
    .dw XT_LITERAL ; postpone

; ( -- addr )
; Interpreter
; Method table for double cell integers
.if cpu_msp430==1
    HEADER(XT_RECTYPE_DNUM,12,"rectype-dnum",DOROM)
.endif

.if cpu_avr8==1
VE_RECTYPE_DNUM:
    .dw $ff0c
    .db "rectype-dnum"
    .dw VE_HEAD
    .set VE_HEAD = VE_RECTYPE_DNUM
XT_RECTYPE_DNUM:
    .dw PFA_DOCONSTANT
PFA_RECTYPE_DNUM:
.endif
    .dw XT_NOOP     ; interpret
    .dw XT_2LITERAL ; compile
    .dw XT_2LITERAL ; postpone

; ( addr len -- f )
; Interpreter
; recognizer for integer numbers
.if cpu_msp430==1
    HEADER(XT_REC_NUM,7,"rec-num",DOCOLON)
.endif

.if cpu_avr8==1

VE_REC_NUM:
    .dw $ff07
    .db "rec-num",0
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
      .dw XT_RECTYPE_NUM
      .dw XT_EXIT
PFA_REC_INTNUM2:
      .dw XT_RECTYPE_DNUM
      .dw XT_EXIT
PFA_REC_NONUMBER:
    .dw XT_RECTYPE_NULL
    .dw XT_EXIT
