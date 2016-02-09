;C IALLOT   n --    allocate n bytes in Code dict
;   IDP +! ;
    HEADER(XT_IALLOT,6,"iallot",DOCOLON)
        DW XT_IDP,XT_PLUSSTORE,XT_EXIT
