;Z !COLON   --      change code field to DOCOLON
;   -2 IALLOT DOCOLON-adrs ,CF ;
; This should be used immediately after CREATE.
; This is made a distinct word, because on an STC
; Forth, colon definitions have no code field.
        HEADER(STORCOLON,6,"!colon",DOCOLON)
        DW XT_DOLITERAL,-2,IALLOT
        DW XT_DOLITERAL,DOCOLON,XT_COMMACF,XT_EXIT
