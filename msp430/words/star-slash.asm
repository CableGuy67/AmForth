;C */     n1 n2 n3 -- n4        n1*n2/n3
;   */MOD nip ;
    HEADER(STARSLASH,2,"*/",DOCOLON)
        DW SSMOD,XT_NIP,XT_EXIT
