; RESTORE copies the first 128 bytes of Info Flash to
; the User Area and subsequent RAM.
        HEADER(RESTORE,7,"RESTORE",DOCOLON)
        DW  XT_DOLITERAL,USAVE,U0,XT_DOLITERAL,INFO_SIZE
        DW  ITOD,XT_EXIT
