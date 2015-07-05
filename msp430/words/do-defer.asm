; : (defer) <builds does> dup @i swap i-cell+ @i execute execute ;
HEADER(XT_DODEFER,7,"(defer)",DOCOLON)
    .dw XT_DOCREATE
    .dw XT_REVEAL
    .dw XT_COMPILE
    .dw DODEFER
    .dw XT_EXIT

HEADLESS(XT_DODODEFER,DODEFER)
DODEFER:
    .dw 04030h, dodoes ; same as got compiled in DOES>
    .dw XT_DUP
    .dw XT_ICELLPLUS
    .dw XT_FETCHI
    .dw XT_EXECUTE
    .dw XT_EXECUTE
    .dw XT_EXIT
