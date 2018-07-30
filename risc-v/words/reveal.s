
COLON Flag_visible, "reveal", REVEAL
    .word XT_NEWEST,XT_CELLPLUS,XT_FETCH # only if wordlist is in use
    .word XT_QDUP,XT_DOCONDBRANCH, REVEAL1
    .word XT_NEWEST,XT_FETCH,XT_SWAP,XT_STORE
REVEAL1:
    .word XT_EXIT
