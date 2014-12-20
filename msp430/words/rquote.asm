    ; IMMED(SQUOTE,2,"S"",DOCOLON)
        DW      link
        DB      0FEh       ; immediate
.set link = $
        DB      2,'r','"'
        .align 16
XT_RQUOTE: DW      DOCOLON
        DW XT_DOLITERAL,XT_DORQUOTE,XT_COMMA
        DW XT_HERE,XT_COMMA,XT_DOLITERAL,22h,XT_PARSE
        DW XT_DUP,XT_TO_R,XT_CCOMMA,XT_IHERE,XT_R_FETCH,DTOI
        DW XT_R_FETCH,XT_1PLUS,ALLOT
        DW XT_R_FROM,XT_IALLOT,ALIGNN,XT_EXIT
