;Z D->I     c-addr1 c-addr2 u --  move Data->Code
; Block move from Data space to Code space.  Flashable.
; For the MSP430, this uses a "smart" algorithm that uses word writes,
; rather than byte writes, whenever possible.  Note that byte reads
; are used for the source, so it need not be aligned.
        CODEHEADER(XT_DTOI,4,"d->i")
        NEXT
