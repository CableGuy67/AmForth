
COLON Flag_visible, "(create)", DOCREATE
    .word XT_PARSENAME,XT_WLSCOPE
    .word XT_DOCREATE_IN         
    .word XT_EXIT

NONAME DOCREATE_IN
    .word XT_DUP,XT_NEWEST,XT_CELLPLUS,XT_STORE
    .word XT_HEADER,XT_NEWEST,XT_STORE         
    .word XT_EXIT
