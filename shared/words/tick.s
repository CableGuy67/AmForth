
COLON "'", TICK
    .word XT_PARSENAME
    .word XT_FORTHRECOGNIZER
    .word XT_RECOGNIZE
    # a word is tickable unless RECTYPE-TOKEN is RECTYPE-NULL or 
    # the interpret action is a NOOP
    .word XT_DUP
    .word XT_RECTYPE_NULL
    .word XT_EQUAL
    .word XT_SWAP
    .word XT_FETCH
    .word XT_DOLITERAL
    .word XT_NOOP
    .word XT_EQUAL
    .word XT_OR
    .word XT_DOCONDBRANCH, PFA_TICK1
      .word XT_DOLITERAL
      .word -13
      .word XT_THROW
PFA_TICK1:
    .word XT_DROP
    .word XT_EXIT

