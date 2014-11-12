;Z NFA>CFA   nfa -- cfa    name adr -> code field
;   HCOUNT 7F AND + ALIGNED ;   mask off 'smudge' bit
    HEADER(NFATOCFA,7,"nfa>cfa",DOCOLON)
        DW XT_ICOUNT
        DW lit,07Fh,XT_AND,XT_PLUS,ALIGNED,XT_EXIT
