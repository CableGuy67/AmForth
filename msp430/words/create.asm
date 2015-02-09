;C CREATE   --      create an empty definition
;   HEADER
;   DOROM ,CF              code field
    HEADER(XT_CREATE,6,"create",DOCOLON)
        DW XT_DOCREATE
        DW XT_DOLITERAL,DOROM,XT_COMMA
        DW XT_EXIT
