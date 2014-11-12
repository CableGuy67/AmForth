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
    .dw XT_FINDNAMEA
    .dw XT_DOLITERAL
    .dw EE_ORDERLISTLEN
    .dw XT_MAPSTACK
    .dw XT_ZEROEQUAL
    .dw XT_DOCONDBRANCH
    .dw PFA_FINDNAME1
      .dw XT_2DROP
      .dw XT_ZERO
PFA_FINDNAME1:
    .dw XT_EXIT

XT_FINDNAMEA:
    .dw DO_COLON
PFA_FINDNAMEA:
    .dw XT_TO_R
    .dw XT_2DUP
    .dw XT_R_FROM
    .dw XT_SEARCH_WORDLIST
    .dw XT_DUP
    .dw XT_ZEROEQUAL
    .dw XT_ZEROEQUAL
    .dw XT_DOCONDBRANCH
    .dw PFA_FINDNAMEA1
      .dw XT_TO_R
      .dw XT_NIP
      .dw XT_NIP
      .dw XT_R_FROM
      .dw XT_TRUE
PFA_FINDNAMEA1:
    .dw XT_EXIT
    
;   : find-name ( addr len -- xt +/-1 | 0)
;      [: ( addr len wid -- xt +/-1 -1 | addr len 0 ) 
;         >r 2dup r>
;         search-wordlist
;         dup 0<> if >r nip nip r> -1 then
;      ;] 
;      EE_ORDERLISTLEN  map-stack 
;      0= if 2drop 0 then
;   ;
