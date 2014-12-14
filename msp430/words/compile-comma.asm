;X COMPILE,  xt --         append execution token
; I called this word ,XT before I discovered that it is defined in the 
; ANSI standard as COMPILE,. On a DTC Forth this simply appends xt 
; (like , ) but on an STC Forth this must append 'CALL xt'.
        ; HEADER(COMMAXT,8,"COMPILE,",DOALIAS)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      8,"compile,"
        .align 16
COMMAXT: DW      DOALIAS        
        DW  XT_COMMA
