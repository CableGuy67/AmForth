;C DEPTH    -- +n        number of items on stack
;   SP@ S0 XT_SWAP - 2/ ;   16-BIT VERSION!
    HEADER(DEPTH,5,"depth",DOCOLON)
        DW XT_SP_FETCH,XT_SP0,XT_SWAP,XT_MINUS,TWOSLASH,XT_EXIT
