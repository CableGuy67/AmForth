
USER "handler", HANDLER, USER_HANDLER

COLON "catch", CATCH

    .word XT_SP_FETCH
    .word XT_TO_R
    .word XT_HANDLER
    .word XT_FETCH
    .word XT_TO_R
    .word XT_RP_FETCH
    .word XT_HANDLER
    .word XT_STORE
    .word XT_EXECUTE
    .word XT_R_FROM
    .word XT_HANDLER
    .word XT_STORE
    .word XT_R_FROM
    .word XT_DROP
    .word XT_ZERO
    .word XT_EXIT
