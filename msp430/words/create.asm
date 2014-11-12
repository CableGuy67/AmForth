;C CREATE   --      create an empty definition
;   HEADER
;   docreate ,CF              code field
;   HERE I, ;           store data adr (Harvard)
; Harvard model, separate Code and Data spaces.
; Separate headers model.
    HEADER(CREATE,6,"create",DOCOLON)
        DW HEADR
        DW lit,docreate,XT_COMMACF
        DW XT_HERE,ICOMMA,XT_EXIT
