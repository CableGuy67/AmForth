;Z FLALIGNED   a -- a'      align IDP to flash boundary
;   $200 OVER - $1FF AND + ;
    HEADER(FLALIGNED,9,"flaligned",DOCOLON)
        DW lit,0200h,XT_OVER,XT_MINUS,lit,01FFh,XT_AND,XT_PLUS,XT_EXIT
