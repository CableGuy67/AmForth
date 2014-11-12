;Z ENDLOOP   adrs xt --   L: 0 a1 a2 .. aN --
;   ,BRANCH  ,DEST                backward loop
;   BEGIN L> ?DUP WHILE POSTPONE THEN REPEAT ;
;                                 resolve LEAVEs
; This is a common factor of LOOP and +LOOP.
    HEADER(ENDLOOP,7,"endloop",DOCOLON)
        DW COMMABRANCH,COMMADEST
LOOP1:  DW LFROM,XT_QDUP,qbran
        DEST(LOOP2)
        DW XT_THEN,bran
        DEST(LOOP1)
LOOP2:  DW XT_EXIT
