;C VARIABLE --            define a Forth VARIABLE
;   CREATE CELL ALLOT ;
; Action of ROMable variable is the same as CREATE; it builds a
; constant holding the RAM address.  See CREATE in hilvl430.s43.
        HEADER(VARIABLE,8,"variable",DOCOLON)
        DW XT_CREATE,XT_TWO,XT_ALLOT,XT_EXIT
