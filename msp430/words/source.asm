;C SOURCE   -- adr n    current input buffer
;   'SOURCE 2@ ;        length is at lower adrs
    DEFER(XT_SOURCE,6,"source")
        DW USER_SOURCE+UAREA
	DW XT_RDEFERFETCH
	DW XT_RDEFERSTORE
