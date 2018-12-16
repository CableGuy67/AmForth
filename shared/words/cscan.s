
COLON "cscan", CSCAN
    .word XT_TO_R
    .word XT_OVER
PFA_CSCAN1:
    .word XT_DUP
    .word XT_CFETCH
    .word XT_R_FETCH
    .word XT_EQUAL
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH,PFA_CSCAN2
      .word XT_SWAP
      .word XT_1MINUS
      .word XT_SWAP
      .word XT_OVER
      .word XT_ZEROLESS 
      .word XT_ZEROEQUAL
      .word XT_DOCONDBRANCH, PFA_CSCAN2
        .word XT_1PLUS
        .word XT_DOBRANCH, PFA_CSCAN1
PFA_CSCAN2:
    .word XT_NIP
    .word XT_OVER
    .word XT_MINUS
    .word XT_R_FROM
    .word XT_DROP
    .word XT_EXIT
