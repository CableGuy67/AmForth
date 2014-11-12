;C LEAVE    --    L: -- adrs
;   ['] UNLOOP ,XT
;   ['] branch ,BRANCH   IHERE ,NONE  >L
;   ; IMMEDIATE      unconditional forward branch
    IMMED(LEAV,5,"leave",DOCOLON)
        DW lit,XT_UNLOOP,COMMAXT
        DW lit,bran,COMMABRANCH
        DW IHERE,COMMANONE,TOL,XT_EXIT
