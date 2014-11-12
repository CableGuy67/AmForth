;C +LOOP   adrs --   L: 0 a1 a2 .. aN --
;   ['] xplusloop ENDLOOP ;  IMMEDIATE
    IMMED(PLUSLOOP,5,"+loop",DOCOLON)
        DW lit,xplusloop,ENDLOOP,XT_EXIT
