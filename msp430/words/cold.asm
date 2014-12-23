;Z COLD     --      cold start Forth system
;   UINIT U0 #INIT I->D      init user area
;   ." MSP430 CamelForth etc."
;   ABORT ;
    HEADER(XT_COLD,4,"cold",DOCOLON)
	DW XT_BASE,XT_ADDR_TO_INFO,XT_FETCH,XT_DOCONDBRANCH
	DEST(COLD1)
	; some valid content in INFO
        DW XT_DOLITERAL, 1000h
	DW XT_DOBRANCH
	DEST(COLD2)
COLD1:
        DW UINIT
COLD2:
	DW U0,NINIT,ITOD
        DW XT_APPLTURNKEY
        DW XT_QUIT

