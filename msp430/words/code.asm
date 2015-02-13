;U MSP430CODE       <name> --       build header for assembler word          
;    <builds ihere ihere 2 -  i!  ;
        HEADER(XT_CODE,4,"code",DOCOLON)
        DW XT_BUILDS,XT_IHERE,XT_DUP,XT_TWO,XT_MINUS,XT_STOREI
        DW XT_REVEAL,XT_EXIT
