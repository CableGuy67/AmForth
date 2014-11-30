;Z HIDE     --      "hide" latest definition    Flashable
;   LATEST @ DUP NEWEST !  NFA>LFA H@ LATEST ! ;
    HEADER(HIDE,4,"hide",DOCOLON)
        DW LATEST,XT_FETCH,XT_DUP,NEWEST,XT_STORE
        DW XT_NFA2LFA,HFETCH,LATEST,XT_STORE,XT_EXIT
