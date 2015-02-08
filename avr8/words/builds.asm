; ( -- ) (C: "<spaces>name" -- )
; Dictionary
; create a dictionary header with an undefined but allocated XT to be set with DOES>
VE_BUILDS:
    .dw $ff07
    .db "<builds"
    .dw VE_HEAD
    .set VE_HEAD = VE_BUILDS
XT_BUILDS:
    .dw DO_COLON
PFA_BUILDS:
    .dw XT_DOCREATE
    .dw XT_REVEAL
    .dw XT_COMPILE
    .dw -1
    .dw XT_EXIT
