;Z >L   x --   L: -- x        move to leave stack
;   CELL LP +!  LP @ ! ;      (L stack grows up)
    HEADER(TOL,2,">l",DOCOLON)
        DW CELL,LP,XT_PLUSSTORE,LP,XT_FETCH,XT_STORE,XT_EXIT
