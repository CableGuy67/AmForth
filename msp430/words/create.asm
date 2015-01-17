;C CREATE   --      create an empty definition
;   HEADER
;   DOROM ,CF              code field
    HEADER(CREATE,6,"create",DOCOLON)
        DW XT_HEADER
        DW XT_DOLITERAL,DOROM,XT_COMMA
        DW XT_EXIT
