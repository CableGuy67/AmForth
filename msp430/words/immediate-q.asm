; ( f -- +/-1 )
; System
; return +1 if immediate, -1 otherwise, flag from name>flags
HEADER(XT_IMMEDIATEQ,10,"immediate?",DOCOLON)
    .dw XT_ONE
    .dw XT_AND
    .dw XT_ZEROEQUAL
    .dw XT_DOCONDBRANCH
    DEST(IMMEDIATEQ1)
     .dw XT_ONE
    .dw XT_EXIT
IMMEDIATEQ1:
    ; not immediate
    .dw XT_TRUE
    .dw XT_EXIT
