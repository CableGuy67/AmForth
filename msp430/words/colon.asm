;C :        --      begin a colon definition  
;   <BUILDS HIDE ] !COLON ;      Flashable version
    HEADER(XT_COLON,1,":",DOCOLON)
        DW XT_DOCREATE,XT_DOLITERAL,DOCOLON,XT_COMMA
	DW XT_RBRACKET
        DW XT_EXIT
