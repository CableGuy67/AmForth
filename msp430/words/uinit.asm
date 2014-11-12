;Z uinit    -- addr  initial values for user area
; MSP430: we also use this to initialize the RAM interrupt
; vectors, which immediately follow the user area.
; Per init430f1611.s43, allocate 16 cells for user
; variables, followed by 30 cells for interrupt vectors.
    HEADER(UINIT,5,"uinit",DOROM)
        DW 0,0,10,0     ; reserved,>IN,XT_BASE,STATE
        DW RAMDICT      ; DP
        DW 0,0          ; SOURCE init'd elsewhere
        DW lastword     ; LATEST
        DW 0,0          ; HP,LP init'd elsewhere
        DW ROMDICT      ; IDP
        DW 0            ; NEWEST not init'd
        DW 0,0,0,0      ; user variables TBD
    ; RAM interrupt vectors, 15 vectors of 2 cells each
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
        MOV #nullirq,PC
