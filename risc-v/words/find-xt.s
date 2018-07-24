
COLON Flag_visible, "find-xt", FINDXT

    .word XT_DOLITERAL
    .word XT_FINDXTA
    .word XT_DOLITERAL
    .word PFA_ORDER
    .word XT_MAPSTACK
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH,PFA_FINDXT1
      .word XT_2DROP
      .word XT_ZERO
PFA_FINDXT1:
    .word XT_EXIT

NONAME FINDXTA
    .word XT_TO_R
    .word XT_2DUP
    .word XT_R_FROM, XT_EXECUTE
    .word XT_SEARCH_WORDLIST
    .word XT_DUP
    .word XT_DOCONDBRANCH,PFA_FINDXTA1
      .word XT_TO_R
      .word XT_NIP
      .word XT_NIP
      .word XT_R_FROM
      .word XT_TRUE
PFA_FINDXTA1:
    .word XT_EXIT

