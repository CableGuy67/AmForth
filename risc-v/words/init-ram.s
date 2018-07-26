
COLON Flag_visible, "init-ram", INIT_RAM

    .word XT_DOLITERAL, HERESTART, XT_DOTO, XT_HERE
    .word XT_DP, XT_DOTO, XT_CURRENT
    .word XT_CFG_RECOGNIZER, XT_DOTO, XT_FORTHRECOGNIZER
    .word XT_DOLITERAL, RAM_lower_userarea, XT_UP_STORE
    .word XT_EXIT
