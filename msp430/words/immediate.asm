;C IMMEDIATE   --   make last def'n immediate
;   0FE LATEST @ 1- HC! ;   set Flashable immediate flag
    HEADER(IMMEDIATE,9,"immediate",DOCOLON)
        DW lit,0FEh,LATEST,XT_FETCH,XT_1MINUS,HCSTORE
        DW XT_EXIT
