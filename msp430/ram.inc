; ----------------------------------------------------------------------
; RAM DATA AREAS 

.org RAMSTART

TIBAREA: DS8   TIB_SIZE       ; Terminal Input Buffer
LSTACK:  DS16  PSTACK_SIZE    ; leave stack grows up into PSTACK area
PSTACK:  DS16    RSTACK_SIZE
RSTACK: ; end of return stack area

; initalized at runtime (e.g. COLD or <# )
UP:          DS16 1    ; User Pointer, set in device init.
RAM_PAUSE:   DS16 1
RAM_STATE:   DS16 1
RAM_HLD:     DS16 1
RAM_LP:      DS16 1 
RAM_NEWEST:  DS16 1
RAM_NUMBERTIB:  DS16 1

; initialized from info flash
RAMINFOAREA:                  ; 128 byte copy from INFO flash or uinit defaults
                              ; configuration stacks. extreme care has to be taken here
CFG_RECOGNIZERLISTLEN:        ; RECOGNIZER stack
	DS16 5                ; place for the count word and 4 slots
CFG_ORDERLISTLEN:             ; ORDER stack
	DS16 9                ; place for the count word and 8 slots
RAM_TURNKEY: DS16 1
RAM_DP:      DS16 1
RAM_IDP:     DS16 1
RAM_LATEST:  DS16 1
RAM_ENVWID:  DS16 1

; default USER area comes from info flash as well
UAREA:  DS8    UAREA_SIZE     ; 
RAMDICT:                      ; start value for HERE.

ROMDICT EQU     FLASHSTART    ; use Flash ROM for program dictionary

; ----------------------------------------------------------------------
; DATA FLASH AREAS 

        .org INFOFLASHSTART      ; start of info Flash
; 128 bytes at start of Info area, for saved User Area & variables
FLASHINFOAREA: 
         DS8  INFO_SIZE
