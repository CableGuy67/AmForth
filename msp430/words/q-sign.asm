;Z ?SIGN   adr n -- adr' n' f  get optional sign
;Z  advance adr/n if sign; return NZ if negative
;   OVER C@                 -- adr n c
;   2C - DUP ABS 1 = AND    -- +=-1, -=+1, else 0
;   DUP IF 1+               -- +=0, -=+2
;       >R 1 /STRING R>     -- adr' n' f
;   THEN ;
    HEADER(QSIGN,5,"?sign",DOCOLON)
        DW XT_OVER,XT_CFETCH,XT_DOLITERAL,2Ch,XT_MINUS,XT_DUP,XT_ABS
        DW XT_ONE,XT_EQUAL,XT_AND,XT_DUP,qbran
        DEST(QSIGN1)
        DW XT_1PLUS,XT_TO_R,XT_ONE,XT_SLASHSTRING,XT_R_FROM
QSIGN1: DW XT_EXIT
