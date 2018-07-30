
COLON Flag_visible, "s,", SCOMMA
    .word XT_DUP
    .word XT_DOSCOMMA
    .word XT_EXIT

NONAME DOSCOMMA
    .word XT_COMMA
    .word XT_DUP    # ( --addr len len)
    .word XT_2SLASH # ( -- addr len len/2
    .word XT_TUCK   # ( -- addr len/2 len len/2
    .word XT_2STAR  # ( -- addr len/2 len len2
    .word XT_MINUS  # ( -- addr len/2 rem
    .word XT_TO_R
    .word XT_ZERO
    .word XT_QDOCHECK
    .word XT_DOCONDBRANCH, PFA_SCOMMA2
    .word XT_DODO
    .word PFA_SCOMMA2
PFA_SCOMMA1:
    .word XT_DUP         # ( -- addr addr )
    .word XT_FETCH       # ( -- addr c1c2 )
    .word XT_COMMA       # ( -- addr )
    .word XT_CELLPLUS    # ( -- addr+cell )
    .word XT_DOLOOP
    .word PFA_SCOMMA1
PFA_SCOMMA2:
    .word XT_R_FROM
    .word XT_GREATERZERO
    .word XT_DOCONDBRANCH, PFA_SCOMMA3
      .word XT_DUP     #  well, tricky
      .word XT_CFETCH
      .word XT_COMMA
PFA_SCOMMA3:
    .word XT_DROP        # ( -- )
    .word XT_EXIT
