
; DOCOLON enters a new high-level thread (colon definition.)
; (internal code fragment, not a Forth word)

DOCOLON: 
        PUSH IP         ; 3 save old IP on return stack
        MOV W,IP        ; 1 set new IP to PFA

; The inner interpreter, called after every word.
DONEXT:
        MOV @IP+,W      ; fetch word address into W
DOEXECUTE:
        MOV @W+,PC      ; fetch code address into PC, W=PFA
