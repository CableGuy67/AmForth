;Z IMMED?    nfa -- f      fetch immediate flag
;   1- HC@ 1 AND 0= ;   Flashable model, LSB=0 if immed
    HEADER(IMMEDQ,6,"immed?",DOCOLON)
        DW XT_1MINUS,HCFETCH,lit,1,XT_AND,XT_ZEROEQUAL,XT_EXIT
