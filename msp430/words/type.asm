;C TYPE    c-addr +n --     type line to term'l
;   ?DUP IF
;     OVER + XT_SWAP DO I C@ EMIT LOOP
;   ELSE DROP THEN ;
    HEADER(XT_TYPE,4,"type",DOCOLON)
        DW XT_QDUP,qbran
        DEST(TYP4)
        DW XT_BOUNDS,xdo
TYP3:   DW XT_I,XT_CFETCH,XT_EMIT,xloop
        DEST(TYP3)
        DW bran
        DEST(TYP5)
TYP4:   DW XT_DROP
TYP5:   DW XT_EXIT
