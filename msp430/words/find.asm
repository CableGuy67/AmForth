;C FIND   c-addr -- c-addr 0   if not found
;C                  xt  1      if immediate
;C                  xt -1      if "normal"
    HEADER(XT_FIND,4,"find",DOCOLON)
    DW XT_DUP,XT_TO_R,XT_COUNT,XT_FINDNAME
    DW XT_DUP,XT_DOCONDBRANCH
    DEST(FIND1)
    DW XT_R_FROM,XT_DROP,XT_EXIT
FIND1:
    DW XT_R_FROM,XT_SWAP,XT_EXIT


; : find dup >r count latest search-wordlist
;    dup if r> drop else r> swap then
; ;