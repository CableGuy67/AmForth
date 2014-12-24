; SAVE erases the first 128 bytes of Info Flash, then
; copies the User Area and subsequent RAM variables there.
        HEADER(SAVE,4,"SAVE",DOCOLON)
        DW  U0,XT_DOLITERAL,USAVE,XT_DOLITERAL,INFO_SIZE
        DW  XT_2DUP,FLERASE,DTOI,XT_EXIT
