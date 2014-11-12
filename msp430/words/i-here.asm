;C IHERE    -- addr   returns Code dictionary ptr
;   IDP @ ;
    HEADER(IHERE,5,"ihere",DOCOLON)
        DW IDP,XT_FETCH,XT_EXIT
