;Z uinit    -- addr  initial values for user area
; MSP430: we also use this to initialize the RAM interrupt
; vectors, which immediately follow the user area.
; Per init430f1611.s43, allocate 16 cells for user
; variables, followed by 30 cells for interrupt vectors.
    HEADER(XT_UINIT,5,"uinit",DOROM)
; CFG Area
	DW 2,XT_REC_WORD,XT_REC_NUM,0,0
	DW 1,CFG_FORTHWID,0,0,0,0,0,0,0
	DW XT_APPLTURNKEY ; TURNKEY vector
	DW RAMDICT        ; HERE / DP
	DW ROMDICT        ; IHERE / IDP
	DW INFODICT       ; INFOHERE / INFODP
	DW CFG_FORTHWID   ; CURRENT
	DW lastword       ; FORTH WID
        DW lastenv        ; environment WID
        DW XT_GET_CURRENT ; wlscope
	DW CFG_RECOGNIZERLISTLEN ; standard recognizer stack
; USER Area
	DW 0,0          ; STATE/FOLLOWER
	DW 0,0,0        ; RP,SP0, SP
        DW 0            ; HANDLER
	DW 10           ; BASE
	DW XT_USART_TX
	DW XT_TRUE
	DW XT_USART_RX
	DW XT_USART_RXQ
	DW XT_SOURCETIB
	DW 0            ; >IN
	DW XT_REFILLTIB
