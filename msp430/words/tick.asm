;C '    -- xt           find word in dictionary
;   BL WORD FIND
;   0= ABORT" ?" ;
    HEADER(XT_TICK,1,27h,DOCOLON)
        DW XT_BL,XT_WORD,FIND,XT_ZEROEQUAL,XISQUOTE
        DB 1,'?'
        DW XT_QABORT,XT_EXIT
