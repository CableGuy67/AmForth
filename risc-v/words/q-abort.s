
COLON Flag_visible, "?abort", QABORT

        .word XT_ROT,XT_DOCONDBRANCH,QABO1
        .word XT_TYPE,XT_ABORT
QABO1:  .word XT_2DROP,XT_EXIT
