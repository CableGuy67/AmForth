;C ENVIRONMENT?  c-addr u -- false   system query
;                         -- i*x true
;   2DROP 0 ;       the minimal definition!
    HEADER(ENVIRONMENTQ,12,"environment?",DOCOLON)
        DW XT_2DROP,lit,0,XT_EXIT
