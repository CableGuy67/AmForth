;Z IS"      --            compile in-line string
;   COMPILE (IS")  [ HEX ]
;   22 PARSE     ( -- c-addr n ) 
;   DUP >R IC,  IHERE R@ D->I
;   R> IALLOT ALIGN ; IMMEDIATE
; Harvard model: string is stored in Code space
    ; IMMED(ISQUOTE,3,"IS"",DOCOLON)
        DW      link
        DB      0FEh       ; immediate
.set link = $
        DB      3,"s",','
        .align 16
XT_SCOMMA: 
	DW      DOCOLON

        DW lit,XT_DOSLITERAL,COMMAXT
        DW XT_DUP,XT_TO_R,ICCOMMA,IHERE,XT_R_FETCH,DTOI
        DW XT_R_FROM,IALLOT,ALIGNN,XT_EXIT
