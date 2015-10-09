;Z (DOES>)  --      run-time action of DOES>
    ; HEADER(XDOES,7,"(DOES>)",DOCOLON)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      7,"(does>)"
        .align 16
XT_DODOES: DW      DOCOLON
        DW XT_R_FROM
        DW XT_NEWEST
        DW XT_CELLPLUS
        DW XT_FETCH
        DW XT_FETCH
        DW XT_NFA2CFA
        DW XT_STOREI
        DW XT_EXIT
