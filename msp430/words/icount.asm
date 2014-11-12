;Z ICOUNT  c-addr1 -- c-addr2 u  counted->adr/len
;   DUP CHAR+ XT_SWAP IC@ ;          from Code space
    HEADER(XT_ICOUNT,6,"icount",DOCOLON)
        DW XT_COUNT,XT_EXIT
