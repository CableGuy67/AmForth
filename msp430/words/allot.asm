;C ALLOT   n --         allocate n bytes in dict
;   DP +! ;
    HEADER(ALLOT,5,"allot",DOCOLON)
        DW DDP,XT_PLUSSTORE,XT_EXIT
