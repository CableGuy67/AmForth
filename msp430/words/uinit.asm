;Z uinit    -- addr  initial values for user area
; MSP430: we also use this to initialize the RAM interrupt
; vectors, which immediately follow the user area.
; Per init430f1611.s43, allocate 16 cells for user
; variables, followed by 30 cells for interrupt vectors.
    HEADER(XT_UINIT,5,"uinit",DOROM)
; CFG Area
	DW 2,XT_REC_WORD,XT_REC_NUM,0,0 ; content of FORTH-RECOGNIZER
	DW 1,CFG_FORTHWID,0,0,0,0,0,0,0 ; content of SEARCH ORDER
	DW XT_APPLTURNKEY ; TURNKEY vector
	DW RAMDICT        ; HERE / DP
	DW ROMDICT        ; IHERE / IDP
	DW INFODICT       ; INFOHERE / INFODP
	DW CFG_FORTHWID   ; CURRENT
	DW lastword       ; FORTH WID
        DW lastenv        ; environment WID
        DW XT_GET_CURRENT ; wlscope vector
	DW CFG_RECOGNIZERLISTLEN ; FORTH-RECOGNIZER
; USER Area
	DW 0,0          ; STATE/FOLLOWER (multitasker)
	DW RSTACK,PSTACK,PSTACK   ; RP0,SP0, SP
        DW 0            ; HANDLER (Exception stack)
	DW 10           ; BASE
	DW XT_USART_TX_POLL  ; EMIT vector
	DW XT_USART_TXQ_POLL ; EMIT? vector
	DW XT_USART_RX_POLL  ; KEY vector
	DW XT_USART_RXQ_POLL ; KEY? vector
	DW XT_SOURCETIB ; SOURCE vector
	DW 0            ; >IN
	DW XT_REFILLTIB ; REFILL vector
