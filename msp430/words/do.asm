;C DO       -- adrs   L: -- 0
;   ['] xdo ,XT   IHERE     target for bwd branch
;   0 >L ; IMMEDIATE           marker for LEAVEs
    IMMED(DO,2,"do",DOCOLON)
        DW lit,xdo,COMMAXT,IHERE
        DW XT_ZERO,TOL,XT_EXIT
