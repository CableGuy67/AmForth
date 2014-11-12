;C S"       --             compile in-line string  OLD DEF'N
;   COMPILE (S")  [ HEX ]
;   HERE I,                     data address
;   22 IWORD
;   IC@ 1+ ALIGNED
;   DUP ALLOT IALLOT ; IMMEDIATE
; Harvard model: string is stored in Code space
;    IMMED  SQUOTE,2,'S"',DOCOLON
;        DW lit,XSQUOTE,COMMAXT
;        DW HERE,ICOMMA,lit,22H,IWORD
;        DW ICFETCH,ONEPLUS,ALIGNED
;        DW DUP,ALLOT,IALLOT,XT_EXIT

;C ."       --         compile string to print
;   POSTPONE IS"  POSTPONE ITYPE ; IMMEDIATE
    ; IMMED(DOTQUOTE,2,"."",DOCOLON)
        DW      link
        DB      0FEh       ; immediate
.set link = $
        DB      2,'.','"'
        .align 16
DOTQUOTE: DW      DOCOLON
        DW ISQUOTE
        DW lit,XT_ITYPE,COMMAXT
        DW XT_EXIT

;Z IWORD     c -- c-addr       WORD to Code space
;   WORD
;   IHERE TUCK OVER C@ CHAR+ D->I ;
    HEADER(XT_IWORD,5,"iword",DOCOLON)
        DW XT_WORD,IHERE,XT_TUCK,XT_OVER,XT_CFETCH
        DW CHARPLUS,DTOI,XT_EXIT
