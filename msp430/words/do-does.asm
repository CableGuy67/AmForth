;Z (DOES>)  --      run-time action of DOES>
;   R>              adrs of headless DOES> def'n
;   LATEST @ NFA>CFA    code field to fix up
;   !CF ;
    ; HEADER(XDOES,7,"(DOES>)",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      7,"(does>)"
        .align 16
XDOES: DW      DOCOLON
        DW XT_R_FROM,LATEST,XT_FETCH,NFATOCFA,XT_STORECF
        DW XT_EXIT
