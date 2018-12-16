
COLON "toupper", TOUPPER
    .word XT_DUP 
    .word XT_DOLITERAL 
    .word 'a' 
    .word XT_DOLITERAL 
    .word 'z'+1
    .word XT_WITHIN 
    .word XT_DOCONDBRANCH,PFA_TOUPPER0
    .word XT_DOLITERAL
    .word 223 
    .word XT_AND 
PFA_TOUPPER0:
    .word XT_EXIT 
