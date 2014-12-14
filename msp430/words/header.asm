;Z HEADER   --      create a Forth word header
;   LATEST @ H, 0FF HC,         link & IMMED  field
;   HHERE LATEST !            new "latest" link
;   BL HWORD HC@ 1+ HALLOT    name field
;   ALIGN ;
; Separate headers model.
    HEADER(HEADR,6,"header",DOCOLON)
        DW XT_GET_CURRENT,HCOMMA    ; link
        DW XT_DOLITERAL,0FFh,HCCOMMA         ; immediate flag - see note below
        DW HHERE,XT_LATEST,XT_STORE
        DW XT_BL,XT_IWORD,HCFETCH,XT_1PLUS,HALLOT
        DW ALIGNN,XT_EXIT   ; MSP430: headers in I space must be aligned
; Note for Flashable MSP430: when compiling to RAM, we need to set
; the immediate byte to 0FFH.  When compiling to Flash, the word IC!
; will not write 0FFH to erased Flash (because the byte is already 0FFH).
; Thus we can write this byte at a later time (with IMMEDIATE).
