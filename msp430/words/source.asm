;C SOURCE   -- adr n    current input buffer
;   'SOURCE 2@ ;        length is at lower adrs
    DEFER(XT_SOURCE,6,"source")
        DW USER_SOURCE
	DW XT_UDEFERFETCH
	DW XT_UDEFERSTORE
