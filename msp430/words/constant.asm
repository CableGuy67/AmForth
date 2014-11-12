;C CONSTANT --            define a Forth constant
;   <BUILDS  I,   Flashable Harvard model
;   DOES> (machine code fragment)
; Note that the constant is stored in Code space.
        HEADER(CONSTANT,8,"constant",DOCOLON)
        DW BUILDS,ICOMMA,XDOES
