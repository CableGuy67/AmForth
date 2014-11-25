;X DUMP  adr n  --   dump memory
;  OVER + SWAP DO
;    CR I 4 U.R SPACE SPACE
;    I $10 + I DO I C@ 3 U.R LOOP  SPACE SPACE
;    I $10 + I DO I C@ $7F AND $7E MIN BL MAX EMIT LOOP
;  10 +LOOP ;
    HEADER(DUMP,4,"dump",DOCOLON)
        DW XT_OVER,XT_PLUS,XT_SWAP,xdo
LDUMP1: DW XT_CR,XT_I,lit,4,XT_UDOTR,XT_SPACE,XT_SPACE
        DW XT_I,lit,10h,XT_PLUS,XT_I,xdo
LDUMP2: DW XT_I,XT_CFETCH,lit,3,XT_UDOTR,xloop
        DEST(LDUMP2)
        DW XT_SPACE,XT_SPACE
        DW XT_I,lit,10h,XT_PLUS,XT_I,xdo
LDUMP3: DW XT_I,XT_CFETCH,lit,7Fh,XT_AND,lit,7Eh,XT_MIN,XT_BL,XT_MAX,XT_EMIT,xloop
        DEST(LDUMP3)
        DW lit,10h,xplusloop
        DEST(LDUMP1)
        DW XT_EXIT
