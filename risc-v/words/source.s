
DEFER "source", SOURCE
.word XT_SOURCETIB

COLON Flag_visible, "source-tib", SOURCETIB

    .word XT_TIB
    .word XT_NUMBERTIB
    .word XT_FETCH
    .word XT_EXIT
