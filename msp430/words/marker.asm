;X MARKER   --      create word to restore dictionary
;   LATEST @ XT_IHERE HERE
;   XT_IHERE FLALIGNED IDP !     align new word to flash boundary
;   <BUILDS I, I, I,        save dp,idp,latest
;   DOES>  DUP I@  
;   XT_SWAP CELL+ DUP I@
;   XT_SWAP CELL+ I@           fetch saved   -- dp idp latest 
;   OVER FLALIGNED XT_IHERE OVER - FLERASE    erase Flash from saved to XT_IHERE
;   LATEST ! IDP ! DP ! ;
    HEADER(MARKER,6,"marker",DOCOLON)
        DW XT_LATEST,XT_FETCH,XT_IHERE,XT_HERE
        DW XT_IHERE,XT_FLALIGNED,IDP,XT_STORE
        DW XT_BUILDS,XT_COMMA,XT_COMMA,XT_COMMA,XT_DODOES
        MOV #dodoes,PC      ; long direct jump to DODOES
        DW XT_DUP,XT_FETCHI
        DW XT_SWAP,XT_CELLPLUS,XT_DUP,XT_FETCHI
        DW XT_SWAP,XT_CELLPLUS,XT_FETCHI
        DW XT_OVER,XT_FLALIGNED,XT_IHERE,XT_OVER,XT_MINUS,XT_FLERASE
        DW XT_LATEST,XT_STORE,IDP,XT_STORE,XT_DP,XT_STORE,XT_EXIT
