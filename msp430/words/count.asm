;C COUNT   c-addr1 -- c-addr2 u  counted->adr/len
;   DUP CHAR+ XT_SWAP C@ ;
    HEADER(XT_COUNT,5,"count",DOCOLON)
        DW XT_DUP,CHARPLUS,XT_SWAP,XT_CFETCH,XT_EXIT
