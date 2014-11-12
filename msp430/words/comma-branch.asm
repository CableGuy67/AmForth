;Z ,BRANCH   xt --    append a branch instruction
; xt is the branch operator to use, e.g. qbranch or (loop).  
; It does NOT append the destination address.  
; On the MSP430 this is equivalent to ,XT (above).
        ; HEADER(COMMABRANCH,7,",BRANCH",DOALIAS)
        DW      link
        DB      0FFh       ; not immediate
.set link = $
        DB      7,",branch"
        .align 16
COMMABRANCH: DW      DOALIAS
        DW  ICOMMA
