
HEADLESS QSIGN

    .word XT_OVER 
    .word XT_CFETCH
    .word XT_DOLITERAL
    .word 45 # '-'
    .word XT_EQUAL  
    .word XT_DUP
    .word XT_TO_R
    .word XT_DOCONDBRANCH, PFA_NUMBERSIGN_DONE
    .word XT_DOLITERAL, 1
    .word XT_SLASHSTRING
PFA_NUMBERSIGN_DONE:
    .word XT_R_FROM
    .word XT_EXIT
