; ----------------------------------------------------------------------
; RAM DATA AREAS 

.org RAMSTART

        DS8    HOLD_SIZE
; HOLDAREA: ; end of hold area - hold area grows down from PAD
PADAREA: DS8   PAD_SIZE       ; must follow HOLDAREA
TIBAREA: DS8   TIB_SIZE       ; Terminal Input Buffer

LSTACK: DS16    PSTACK_SIZE   ; leave stack grows up into PSTACK area
PSTACK: ; end of parameter stack area
        DS16    RSTACK_SIZE
RSTACK: ; end of return stack area

; initalized in COLD
UP:     DS16    1             ; User Pointer, set in device init.
RAM_PAUSE:                    ; some actions
	DS16 1
RAM_STATE:
	DS16 1

; initialized from info flash
RAMINFOAREA:                  ; 128 byte copy from INFO flash or uinit defaults
                              ; configuration stacks. extreme care has to be taken here
CFG_RECOGNIZERLISTLEN:        ; RECOGNIZER stack
	DS16 5                ; place for the count word and 4 slots
CFG_ORDERLISTLEN:             ; ORDER stack
	DS16 9                ; place for the count word and 8 slots
RAM_TURNKEY:
	DS16 1
RAM_DP:
	DS16 1
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
