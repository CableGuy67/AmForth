;Z ?NUMBER  c-addr -- n -1      string->number
;Z                 -- c-addr 0  if convert error
;   DUP  0 0 ROT COUNT      -- ca ud adr n
;   ?SIGN >R  >NUMBER       -- ca ud adr' n'
;   IF   R> 2DROP 2DROP 0   -- ca 0   (error)
;   ELSE 2DROP NIP R>
;       IF NEGATE THEN  -1  -- n -1   (ok)
;   THEN ;
    HEADER(QNUMBER,7,"?number",DOCOLON)
        DW XT_DUP,XT_ZERO,XT_DUP,XT_ROT,XT_COUNT
        DW QSIGN,XT_TO_R,XT_TO_NUMBER,XT_DOCONDBRANCH
        DEST(QNUM1)
        DW XT_R_FROM,XT_2DROP,XT_2DROP,XT_ZERO
        DW XT_DOBRANCH
        DEST(QNUM3)
QNUM1:  DW XT_2DROP,XT_NIP,XT_R_FROM,XT_DOCONDBRANCH
        DEST(QNUM2)
        DW XT_NEGATE
QNUM2:  DW XT_MINUSONE
QNUM3:  DW XT_EXIT
