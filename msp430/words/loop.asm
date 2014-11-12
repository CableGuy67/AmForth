;C LOOP    adrs --   L: 0 a1 a2 .. aN --
;   ['] xloop ENDLOOP ;  IMMEDIATE
    IMMED(LOO,4,"loop",DOCOLON)
        DW lit,xloop,ENDLOOP,XT_EXIT
