; : (value) <builds does> dup @i swap i-cell+ @i execute ;
HEADER(XT_DOVALUE,7,"(value)",DOCOLON)
    .dw XT_DOCREATE
    .dw XT_REVEAL
    .dw XT_COMPILE
    .dw DOVALUE
    .dw XT_EXIT

HEADLESS(XT_DODOVALUE,DOVALUE)
DOVALUE:
    .dw 04030h, dodoes ; same as got compiled in DOES>
    .dw XT_DUP
    .dw XT_ICELLPLUS
    .dw XT_FETCHI
    .dw XT_EXECUTE
    .dw XT_EXIT
