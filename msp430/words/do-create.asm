; create a dictionary entry

HEADER(XT_DOCREATE,8,"(create)",DOCOLON)
        DW XT_PARSENAME,XT_WLSCOPE  ; ( -- addr len wid)
	DW XT_DUP,XT_NEWEST,XT_CELLPLUS,XT_STORE ; save the wid
	DW XT_HEADER,XT_NEWEST,XT_STORE          ; save the nt
	DW XT_EXIT
