;Z IS"      --            compile in-line string  OLD DEF'N
;   COMPILE (IS")  [ HEX ]
;   22 IWORD
;   IC@ 1+ ALIGNED IALLOT ; IMMEDIATE
; Harvard model: string is stored in Code space
;   IMMED  ISQUOTE,3,"IS"',DOCOLON
;       DW lit,XISQUOTE,COMMAXT
;       DW lit,22H,IWORD
;       DW ICFETCH,ONEPLUS,ALIGNED,IALLOT,XT_EXIT

;C S"       --             compile in-line string
;   COMPILE (S")  [ HEX ]
;   HERE I,                     data address
;   22 PARSE     ( -- c-addr n ) 
;   DUP >R IC,  IHERE R@ D->I
;   R@ 1+ ALLOT                 reserve RAM space
;   R> IALLOT ALIGN ; IMMEDIATE
; Harvard model: string is stored in Code space
    ; IMMED(SQUOTE,2,"S"",DOCOLON)
        DW      link
        DB      0FEh       ; immediate
.set link = $
        DB      2,'s','"'
        .align 16
SQUOTE: DW      DOCOLON
        DW lit,XSQUOTE,COMMAXT
        DW XT_HERE,ICOMMA,lit,22h,XT_PARSE
        DW XT_DUP,XT_TO_R,ICCOMMA,IHERE,XT_R_FETCH,DTOI
        DW XT_R_FETCH,XT_1PLUS,ALLOT
        DW XT_R_FROM,IALLOT,ALIGNN,XT_EXIT
