;C LITERAL  x --        append numeric literal
;   STATE @ IF ['] LIT ,XT I, THEN ; IMMEDIATE
; This tests STATE so that it can also be used
; interpretively.  (ANSI doesn't require this.)
    IMMED(LITERAL,7,"literal",DOCOLON)
        DW XT_STATE,XT_FETCH,qbran
        DEST(LITER1)
        DW lit,lit,COMMAXT,ICOMMA
LITER1: DW XT_EXIT
