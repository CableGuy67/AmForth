;Z <BUILDS  --      define a word with t.b.d. action & no data
;   HEADER 2 IALLOT ;       Flashable: do not store Code Field
    HEADER(BUILDS,7,"<builds",DOCOLON)
        DW HEADR,lit,2,IALLOT,XT_EXIT
