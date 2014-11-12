;Z #init    -- n    #bytes of user area init data
    HEADER(NINIT,5,"#init",DOCON)
        DW (UAREA_SIZE+VECS_SIZE)*2     ; SIZEs given in cells
