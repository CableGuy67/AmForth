;X .S      --           print stack contents
;   SP@ S0 - IF
;       SP@ S0 2 - DO I @ U. -2 +LOOP
;   THEN ;
    HEADER(XT_DOTS,2,".s",DOCOLON)
        DW XT_SP_FETCH,XT_SP0,XT_MINUS,qbran
        DEST(DOTS2)
        DW XT_SP_FETCH,XT_SP0,lit,2,XT_MINUS,xdo
DOTS1:  DW XT_I,XT_FETCH,XT_UDOT,lit,-2,xplusloop
        DEST(DOTS1)
DOTS2:  DW XT_EXIT
