; ( -- n2 ) 
; Extended VM
; Read memory pointed to by register B (Extended VM)
CODEHEADER(XT_BFETCH,2,"b@")
    SUB #2,PSP
    MOV TOS,0(PSP)
    MOV @REG_B,TOS
    NEXT

; ( n1 -- n2 )
; Extended VM
; Read memory pointed to by register B plus offset (Extended VM)
CODEHEADER(XT_NBFETCH,3,"nb@")
    ADD REG_B,TOS
    MOV @TOS,TOS
    NEXT

; ( -- n ) 
; Extended VM
; Read memory pointed to by register B, increment B by 1 cell (Extended VM)
CODEHEADER(XT_BFETCHPLUS,3,"b@+")
    SUB #2,PSP
    MOV TOS,0(PSP)
    ADD REG_B,TOS
    MOV @TOS,TOS
    ADD #2,REG_B
    NEXT

; ( -- n )
; Extended VM
; Read memory pointed to by register B, decrement B by 1 cell (Extended VM)
CODEHEADER(XT_BFETCHMINUS,3,"b@-")
    SUB #2,PSP
    MOV TOS,0(PSP)
    ADD REG_B,TOS
    MOV @TOS,TOS
    SUB #2,REG_B
    NEXT

; ( n -- )
; Extended VM
; Write memory pointed to by register B (Extended VM)
CODEHEADER(XT_BSTORE,2,"b!")
    MOV TOS,@REG_B
    MOV @PSP+,TOS
    NEXT

; ( n offs -- )
; Extended VM
; Write memory pointed to by register B plus offset (Extended VM)
CODEHEADER(XT_NBSTORE,3,"nb!")
    ADD REG_B, TOS
    MOV @PSP+,X
    MOV X,@TOS
    MOV @PSP+,TOS
    NEXT

; ( -- n2 )
; Extended VM
; Write memory pointed to by register B, increment B by 1 cell (Extended VM)
CODEHEADER(XT_BSTOREPLUS,3,"b!+")
    MOV TOS,@REG_B
    MOV @PSP+,TOS
    ADD #2,REG_B
    NEXT

; ( -- n2 )
; Extended VM
; Write memory pointed to by register B, decrement B by 1 cell (Extended VM)
CODEHEADER(XT_BSTOREMINUS,3,"b!-")
    MOV TOS,@REG_B
    MOV @PSP+,TOS
    SUB #2,REG_B
    NEXT

; ( n -- )
; Extended VM
; Write to B register (Extended VM)
CODEHEADER(XT_TO_B,2,">b")
    MOV TOS,REG_B
    MOV @PSP+,TOS
    NEXT

; ( n1 -- n2 ) 
; Extended VM
; read the B register (Extended VM)
CODEHEADER(XT_B_FROM,2,"b>")
    SUB #2,PSP
    MOV REG_B,TOS
    NEXT

; for more information read
; http://www.complang.tuwien.ac.at/anton/euroforth/ef08/papers/pelc.pdf
;  adapted index based access from X/Y registers
;    note: offset is byte address, not cell!
