;C FIND   c-addr -- c-addr 0   if not found
;C                  xt  1      if immediate
;C                  xt -1      if "normal"
;   LATEST @ BEGIN             -- a nfa
;       2DUP OVER C@ CHAR+     -- a nfa a nfa n+1
;       N=                     -- a nfa f
;       DUP IF
;           DROP
;           NFA>LFA H@ DUP     -- a link link
;       THEN
;   0= UNTIL                   -- a nfa  OR  a 0
;   DUP IF
;       NIP DUP NFA>CFA        -- nfa xt
;       XT_SWAP IMMED?            -- xt iflag
;       0= 1 OR                -- xt 1/-1
;   THEN ;
    HEADER(FIND,4,"find",DOCOLON)
        DW LATEST,XT_FETCH
FIND1:  DW XT_2DUP,XT_OVER,XT_CFETCH,CHARPLUS
        DW NEQUAL,XT_DUP,qbran
        DEST(FIND2)
        DW XT_DROP,XT_NFA2LFA,HFETCH,XT_DUP
FIND2:  DW XT_ZEROEQUAL,qbran
        DEST(FIND1)
        DW XT_DUP,qbran
        DEST(FIND3)
        DW XT_NIP,XT_DUP,NFATOCFA
        DW XT_SWAP,IMMEDQ,XT_ZEROEQUAL,lit,1,XT_OR
FIND3:  DW XT_EXIT
