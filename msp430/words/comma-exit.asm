;Z ,XT_EXIT    --      append hi-level EXIT action
;   ['] EXIT ,XT ;
; This is made a distinct word, because on an STC
; Forth, it appends a RET instruction, not an xt.
        ; HEADER(CEXIT,5,",XT_EXIT",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      5,",exit"
        .align 16
CEXIT: DW      DOCOLON        
        DW XT_DOLITERAL,XT_EXIT,XT_COMMA,XT_EXIT
