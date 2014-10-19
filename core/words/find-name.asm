; ( addr len --  0 | xt -1 | xt 1 ) 
; Tools
; search wordlists for the name from string addr/len
VE_FINDNAME:
    .dw $ff09
    .db "find-name",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FINDNAME
XT_FINDNAME:
    .dw DO_COLON
PFA_FINDNAME:
    .dw XT_DOLITERAL
    .dw XT_FINDNAME2
    .dw XT_DOLITERAL
    .dw EE_ORDERLISTLEN
    .dw XT_MAPSTACK
    .dw XT_DROP
    .dw XT_EXIT

XT_FINDNAME2:
    .dw DO_COLON
PFA_FINDNAME2:
    .dw XT_SEARCH_WORDLIST
    .dw XT_DUP
    .dw XT_EQUALZERO
    .dw XT_EQUALZERO
    .dw XT_EXIT
    
; : map-find ( addr len -- xt +/-1 | 0 )
;    [: ( -- addr len wid ) search-wordlist dup 0= 0= ;] 
;    EE_ORDERLISTLEN  map-stack drop
; ;
