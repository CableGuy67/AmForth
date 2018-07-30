
COLON Flag_visible, "(create)", DOCREATE
    .word XT_PARSENAME,XT_WLSCOPE  # ( -- addr len wid)
    .word XT_DOCREATE_IN           # ( addr len wid -- )
    .word XT_EXIT

NONAME DOCREATE_IN
    .word XT_DUP,XT_NEWEST,XT_CELLPLUS,XT_STORE # save the wid
    .word XT_HEADER,XT_NEWEST,XT_STORE          # save the nt
    .word XT_EXIT
