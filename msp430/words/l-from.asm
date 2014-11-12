;Z L>   -- x   L: x --      move from leave stack
;   LP @ @  CELL NEGATE LP +! ;
    HEADER(LFROM,2,"l>",DOCOLON)
        DW LP,XT_FETCH,XT_FETCH
        DW CELL,XT_NEGATE,LP,XT_PLUSSTORE,XT_EXIT
