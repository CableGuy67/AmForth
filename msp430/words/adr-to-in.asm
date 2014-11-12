;Z ADR>IN   c-addr' --    set >IN to offset to given adr
;   SOURCE         -- adr' adr n
;   ROT ROT -      -- n adr'-adr
;   MIN  0 MAX     -- n'
;   >IN ! ;
    HEADER(ADRTOIN,6,"adr>in",DOCOLON)
        DW XT_SOURCE,XT_ROT,XT_ROT,XT_MINUS,XT_MIN,lit,0,XT_MAX
        DW XT_TO_IN,XT_STORE,XT_EXIT
