CODEHEADER(XT_COLD,4,"cold")
main:   ; Debugger requires the 'main' symbol.
reset:
   mov #5A80h, &WDTCTL ; Watchdog off

   bic   #LOCKLPM5, &PM5CTL0  ; Unlock I/O pins
   mov.b #64, &0225h ; P4DIR  ; Red LED on
;   mov.b #64, &0223h ; P4OUT


  mov #0A500h, &MPUCTL0 ; Write password to enable access to MPU
  mov #FLASHSTART>>4, &MPUSEGB1 ; B1 = Start of memory
  mov #1000h, &MPUSEGB2 ; B2 = 0x10000 (Segment 3 is upper mem)
;  bic #32, &MPUSAM ; Write protect segment 2
  mov #7777h, &MPUSAM ; no protection at all.
  mov #0A501h, &MPUCTL0 ; Enable MPU
  mov.b #0, &MPUCTL0+1 ; Disable MPU access


  ;------------------------------------------------------------------------------
  ; Init Clock

  mov #0A500h, &CSCTL0 ; Enable access to clock registers
  mov #0, &CSCTL3      ; Set all clock dividers to /1
  mov.b #0, &CSCTL0+1  ; Disable access to clock registers


  ;------------------------------------------------------------------------------
  ; Forth registers
  MOV     #RSTACK,SP              ; set up stack
  MOV     #PSTACK,PSP
  MOV     #UAREA,UP              ; initial user pointer

  ; now hand over to Forth with WARM (a colon word)
  MOV     #XT_WARM+2,IP
  NEXT
