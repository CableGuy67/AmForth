;C SOURCE   -- adr n    current input buffer
;   'SOURCE 2@ ;        length is at lower adrs
    HEADER(XT_SOURCE,6,"source",DOCOLON)
        DW TICKSOURCE,TWOFETCH,XT_EXIT
