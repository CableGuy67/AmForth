;Z <BUILDS  --      define a word with t.b.d. action & no data
;   HEADER 2 IALLOT ;       Flashable: do not store Code Field
    HEADER(BUILDS,7,"<builds",DOCOLON)
        DW XT_HEADER,XT_TWO,XT_IALLOT,XT_EXIT
