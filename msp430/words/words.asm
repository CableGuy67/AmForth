;X WORDS    --          list all words in dict.
;   LATEST @ BEGIN
;       DUP HCOUNT 7F AND HTYPE SPACE
;       NFA>LFA H@
;   DUP 0= UNTIL
;   DROP ;
    HEADER(XT_WORDS,5,"words",DOCOLON)
        DW LATEST,XT_FETCH
WDS1:   DW XT_DUP,XT_ICOUNT,lit,07Fh,XT_AND,XT_ITYPE,XT_SPACE
        DW XT_NFA2LFA,HFETCH
        DW XT_DUP,XT_ZEROEQUAL,qbran
        DEST(WDS1)
        DW XT_DROP,XT_EXIT
