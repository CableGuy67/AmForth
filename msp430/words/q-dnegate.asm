;Z ?DNEGATE  d1 n -- d2   negate d1 if n negative
;   0< IF DNEGATE THEN ;       ...a common factor
    HEADER(XT_QDNEGATE,8,"?dnegate",DOCOLON)
        DW XT_ZEROLESS,qbran
        DEST(DNEG1)
        DW XT_DNEGATE
DNEG1:  DW XT_EXIT
