;C ALIGNED  addr -- a-addr       align given addr
;   DUP 1 AND + ;
        HEADER(ALIGNED,7,"aligned",DOCOLON)
        DW  XT_DUP,lit,1,XT_AND,XT_PLUS,XT_EXIT
