; create a dictionary entry

HEADER(XT_WLSCOPE,6,"wlsope",DOCOLON)
    DW XT_GET_CURRENT
    DW XT_EXIT

HEADER(XT_DOCREATE,8,"(create)",DOCOLON)
        DW XT_PARSENAME,XT_WLSCOPE  ; ( -- addr len wid)
	DW XT_HEADER,XT_NEWEST,XT_STORE
	DW XT_EXIT
