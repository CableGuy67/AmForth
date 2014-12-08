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
        DB      2,"s",'"'
        .align 16
XT_SQUOTE: DW      DOCOLON
        DW lit,22h,XT_PARSE
	DW XT_SCOMMA
        DW XT_EXIT
