;C POSTPONE  --   postpone compile action of word
;   BL WORD FIND
;   DUP 0= ABORT" ?"
;   0< IF   -- xt  non immed: add code to current
;                  def'n to compile xt later.
;       ['] LIT ,XT  I,     add "LIT,xt,COMMAXT"
;       ['] ,XT ,XT         to current definition
;   ELSE  ,XT      immed: compile into cur. def'n
;   THEN ; IMMEDIATE
    IMMED(POSTPONE,8,"postpone",DOCOLON)
        DW XT_BL,XT_WORD,FIND,XT_DUP,XT_ZEROEQUAL,XT_DOSLITERAL
        DB 1,'?'
        DW XT_QABORT,XT_ZEROLESS,qbran
        DEST(POST1)
        DW lit,lit,COMMAXT,ICOMMA
        DW lit,COMMAXT,COMMAXT,bran
        DEST(POST2)
POST1:  DW COMMAXT
POST2:  DW XT_EXIT
