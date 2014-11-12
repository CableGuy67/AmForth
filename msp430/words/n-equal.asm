;Z N=    c-addr1 c-addr2 u -- n   name compare
;Z             n<0: s1<s2, n=0: s1=s2, n>0: s1>s2
; For Harvard model, c-addr1 is Data, c-addr2 is Header.
; On MSP430, both use the same fetch instruction, so N= is the same as S=.
        HEADER(NEQUAL,2,"n=",SEQUAL+2)

