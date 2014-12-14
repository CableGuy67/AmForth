;Z IWORD     c -- c-addr       WORD to Code space
;   WORD
;   IHERE TUCK OVER C@ CHAR+ D->I ;
    HEADER(XT_IWORD,5,"iword",DOCOLON)
        DW XT_WORD,IHERE,XT_TUCK,XT_OVER,XT_CFETCH
        DW CHARPLUS,DTOI,XT_EXIT
