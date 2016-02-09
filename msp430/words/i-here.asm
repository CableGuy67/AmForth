;C XT_IHERE    -- addr   returns Code dictionary ptr
;   IDP @ ;
    HEADER(XT_IHERE,5,"ihere",DOCOLON)
        DW XT_IDP,XT_FETCH,XT_EXIT
