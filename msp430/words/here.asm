;C HERE    -- addr      returns dictionary ptr
;   DP @ ;
    HEADER(XT_HERE,4,"here",DOCOLON)
        DW DDP,XT_FETCH,XT_EXIT
