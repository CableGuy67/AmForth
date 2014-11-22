;C '    -- xt           find word in dictionary
;   BL WORD FIND
;   0= if -13 throw then ;
    HEADER(XT_TICK,1,27h,DOCOLON)
    .DW XT_BL,XT_WORD,FIND,XT_ZEROEQUAL
    .dw XT_DOCONDBRANCH
    DEST(PFA_TICK1)
    .dw XT_DOLITERAL
    .dw -13
    .dw XT_THROW
PFA_TICK1:
    .dw XT_EXIT
