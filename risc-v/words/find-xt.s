
COLON Flag_visible, "find-xt", FINDXT

    .word XT_TO_R
    .word XT_2DUP
    .word XT_R_FROM
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
