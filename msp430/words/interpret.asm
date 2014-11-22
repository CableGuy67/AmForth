;Z INTERPRET    i*x c-addr u -- j*x
;Z                      interpret given buffer
; This is a common factor of EVALUATE and QUIT.
; ref. dpANS-6, 3.4 The Forth Text Interpreter
;   'SOURCE 2!  0 >IN !
;   BEGIN
;   BL WORD DUP C@ WHILE        -- textadr
;       FIND                    -- a 0/1/-1
;       ?DUP IF                 -- xt 1/-1
;           1+ STATE @ 0= OR    IMMED  or interp?
;           IF EXECUTE ELSE ,XT THEN
;       ELSE                    -- textadr
;           ?NUMBER
;           IF POSTPONE LITERAL     converted ok
;           ELSE COUNT TYPE -13 THROW
;           THEN
;       THEN
;   REPEAT DROP ;
    HEADER(XT_INTERPRET,9,"interpret",DOCOLON)
        DW TICKSOURCE,TWOSTORE,XT_ZERO,XT_TO_IN,XT_STORE
INTER1: DW XT_BL,XT_WORD,XT_DUP,XT_CFETCH,qbran
        DEST(INTER9)
        DW FIND,XT_QDUP,qbran
        DEST(INTER4)
        DW XT_1PLUS,XT_STATE,XT_FETCH,XT_ZEROEQUAL,XT_OR
        DW qbran
        DEST(INTER2)
        DW XT_EXECUTE,bran
        DEST(INTER3)
INTER2: DW COMMAXT
INTER3: DW bran
        DEST(INTER8)
INTER4: DW QNUMBER,qbran
        DEST(INTER5)
        DW LITERAL,bran
        DEST(INTER6)
INTER5: DW XT_COUNT,XT_TYPE,lit,-13,XT_THROW
INTER6: 
INTER8: DW XT_QSTACK
	DW bran
        DEST(INTER1)
INTER9: DW XT_DROP,XT_EXIT
