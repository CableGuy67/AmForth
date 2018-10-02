COLON Flag_visible, "throw", THROW

    .word XT_QDUP
    .word XT_DOCONDBRANCH,PFA_THROW1
      .word XT_HANDLER
      .word XT_FETCH
      .word XT_RP_STORE
      .word XT_R_FROM
      .word XT_HANDLER
      .word XT_STORE
      .word XT_R_FROM
      .word XT_SWAP
      .word XT_TO_R
      .word XT_SP_STORE
      .word XT_DROP
      .word XT_R_FROM    
PFA_THROW1:
    .word XT_EXIT

