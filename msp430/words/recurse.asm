;C RECURSE  --      recurse current definition
;   LATEST @ NFA>CFA ,XT ; IMMEDIATE
;   NEWEST @ NFA>CFA ,XT ; IMMEDIATE   Flashable
    IMMED(RECURSE,7,"recurse",DOCOLON)
        DW NEWEST,XT_FETCH,XT_NFA2CFA,XT_COMMA,XT_EXIT
