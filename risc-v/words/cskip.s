
COLON Flag_visible, "cskip", CSKIP

    .word XT_TO_R
PFA_CSKIP1:
    .word XT_DUP      
    .word XT_DOCONDBRANCH, PFA_CSKIP2
    .word XT_OVER         
    .word XT_CFETCH       
    .word XT_R_FETCH      
    .word XT_EQUAL        
    .word XT_DOCONDBRANCH, PFA_CSKIP2
    .word XT_DOLITERAL,1
    .word XT_SLASHSTRING
    .word XT_DOBRANCH, PFA_CSKIP1
PFA_CSKIP2:
    .word XT_R_FROM
    .word XT_DROP          
    .word XT_EXIT
