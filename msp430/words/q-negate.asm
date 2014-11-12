;Z ?NEGATE  n1 n2 -- n3  negate n1 if n2 negative
;   0< IF NEGATE THEN ;        ...a common factor
    HEADER(XT_QNEGATE,7,"?negate",DOCOLON)
        DW XT_ZEROLESS,qbran
        DEST(QNEG1)
        DW XT_NEGATE
QNEG1:  DW XT_EXIT
