;X MARKER   --      create word to restore dictionary
;   LATEST @ IHERE HERE
;   IHERE FLALIGNED IDP !     align new word to flash boundary
;   <BUILDS I, I, I,        save dp,idp,latest
;   DOES>  DUP I@  
;   XT_SWAP CELL+ DUP I@
;   XT_SWAP CELL+ I@           fetch saved   -- dp idp latest 
;   OVER FLALIGNED IHERE OVER - FLERASE    erase Flash from saved to IHERE
;   LATEST ! IDP ! DP ! ;
    HEADER(MARKER,6,"marker",DOCOLON)
        DW LATEST,XT_FETCH,IHERE,XT_HERE
        DW IHERE,FLALIGNED,IDP,XT_STORE
        DW BUILDS,ICOMMA,ICOMMA,ICOMMA,XDOES
        MOV #dodoes,PC      ; long direct jump to DODOES
        DW XT_DUP,IFETCH
        DW XT_SWAP,XT_CELLPLUS,XT_DUP,IFETCH
        DW XT_SWAP,XT_CELLPLUS,IFETCH
        DW XT_OVER,FLALIGNED,IHERE,XT_OVER,XT_MINUS,FLERASE
        DW LATEST,XT_STORE,IDP,XT_STORE,DDP,XT_STORE,XT_EXIT
