;Z (DOES>)  --      run-time action of DOES>
    ; HEADER(XDOES,7,"(DOES>)",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      7,"(does>)"
        .align 16
XT_DODOES: DW      DOCOLON
        DW XT_R_FROM,XT_NEWEST,XT_CELLPLUS,XT_FETCH,XT_FETCH,XT_NFA2CFA,XT_STOREI
        DW XT_EXIT
