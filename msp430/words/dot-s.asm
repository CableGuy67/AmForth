;X .S      --           print stack contents
;   SP@ S0 - IF
;       SP@ S0 2 - DO I @ U. -2 +LOOP
;   THEN ;
    HEADER(XT_DOTS,2,".s",DOCOLON)
        DW XT_DEPTH,XT_UDOT,XT_SPACE
	DW XT_DEPTH, XT_QDUP,qbran
        DEST(DOTS2)
        DW XT_ZERO,xdo
DOTS1:  DW XT_I,XT_PICK,XT_UDOT,xloop
        DEST(DOTS1)
DOTS2:  DW XT_EXIT
