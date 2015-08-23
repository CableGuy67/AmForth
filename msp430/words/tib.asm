;X tib     -- a-addr     Terminal Input Buffer
;  HEX 80 USER TIB       8086: above user area
    HEADER(XT_TIB,3,"tib",DOUSER)
        DW TIBAREA-UAREA

    HEADLESS(XT_TIB_SOURCE,DOCOLON)
	DW XT_TIB
	DW XT_NUMBERTIB
	DW XT_FETCH
	DW XT_EXIT

    VARIABLE(XT_NUMBERTIB,4,"#tib")
	DW RAM_NUMBERTIB
