;C    d1 n1 -- n2 n3   floored signed div'n
;                            courtesy of Ed Smeda
;   DUP >R  SM/REM  2DUP  1 <  AND  IF
;     XT_SWAP R@ +  SWAP 1-  THEN
;   R> DROP ;
; Ref. dpANS-6 section 3.2.2.1.
;    HEADER  FMSLASHMOD,6,'FM/MOD',DOCOLON
;	DW DUP,XT_TO_R,SMSLASHREM
;        DW XT_2DUP,lit,1,LESS,XT_AND,qbran
;        DEST  FMMOD1
;        DW XT_SWAP,XT_R_FETCH,XT_PLUS,SWAP,ONEMINUS
;FMMOD1: DW XT_R_FROM,XT_DROP,XT_EXIT

; Fixed FM/MOD, added 12 nov 2012
;C FM/MOD   d1 n1 -- n2 n3   floored signed div'n
;   DUP >R              divisor
;   2DUP XOR >R         sign of quotient
;   >R                  divisor
;   DABS R@ ABS UM/MOD
;   XT_SWAP R> ?NEGATE SWAP  apply sign to remainder
;   R> 0< IF              if quotient negative,
;       NEGATE
;       OVER IF             if remainder nonzero,
;         R@ ROT -  XT_SWAP 1-     adjust rem,quot
;       THEN
;   THEN  R> DROP ;
; Ref. dpANS-6 section 3.2.2.1.
    HEADER(FMSLASHMOD,6,"fm/mod",DOCOLON)
        DW XT_DUP,XT_TO_R,XT_2DUP,XT_XOR,XT_TO_R,XT_TO_R
        DW XT_DABS,XT_R_FETCH,XT_ABS,XT_UMSLASHMOD
        DW XT_SWAP,XT_R_FROM,XT_QNEGATE,XT_SWAP,XT_R_FROM,XT_ZEROLESS,qbran
        DEST(FMMOD1)
        DW XT_NEGATE,XT_OVER,qbran
        DEST(FMMOD2)
        DW XT_R_FETCH,XT_ROT,XT_MINUS,XT_SWAP,XT_1MINUS
FMMOD2: 
FMMOD1: DW XT_R_FROM,XT_DROP,XT_EXIT
