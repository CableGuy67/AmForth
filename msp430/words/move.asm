;C MOVE    addr1 addr2 u --     smart move
;             VERSION FOR 1 ADDRESS UNIT = 1 CHAR
;  >R 2DUP XT_SWAP DUP R@ +     -- ... dst src src+n
;  WITHIN IF  R> CMOVE>        src <= dst < src+n
;       ELSE  R> CMOVE  THEN ;          otherwise
    HEADER(MOVE,4,"move",DOCOLON)
        DW XT_TO_R,XT_2DUP,XT_SWAP,XT_DUP,XT_R_FETCH,XT_PLUS
        DW WITHIN,qbran
        DEST(MOVE1)
        DW XT_R_FROM,XT_CMOVEUP,bran
        DEST(MOVE2)
MOVE1:  DW XT_R_FROM,XT_CMOVE
MOVE2:  DW XT_EXIT
