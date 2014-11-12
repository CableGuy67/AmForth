;Z COLD     --      cold start Forth system
;   UINIT U0 #INIT I->D      init user area
;   ." MSP430 CamelForth etc."
;   ABORT ;
    HEADER(XT_COLD,4,"cold",DOCOLON)
        DW UINIT,U0,NINIT,ITOD
        DW XT_APPLTURNKEY
        DW XT_QUIT

