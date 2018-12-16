
COLON "interpret", INTERPRET
    .word XT_PARSENAME 
    .word XT_DUP
    .word XT_DOCONDBRANCH,PFA_INTERPRET2
      .word XT_FORTHRECOGNIZER
      .word XT_RECOGNIZE
      .word XT_STATE
      .word XT_FETCH
      .word XT_DOCONDBRANCH, PFA_INTERPRET1
        .word XT_CELLPLUS   
PFA_INTERPRET1:
      .word XT_FETCH
      .word XT_EXECUTE
      .word XT_QSTACK
    .word XT_DOBRANCH, PFA_INTERPRET
PFA_INTERPRET2:
    .word XT_2DROP
    .word XT_EXIT
