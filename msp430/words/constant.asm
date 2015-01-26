;C CONSTANT --            define a Forth constant
;   <BUILDS  I,   Flashable Harvard model
;   DOES> (machine code fragment)
; Note that the constant is stored in Code space.
        HEADER(XT_CONSTANT,8,"constant",DOCOLON)
        DW XT_BUILDS,XT_COMMA,XDOES
