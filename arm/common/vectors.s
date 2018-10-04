
.word RAM_upper_returnstack @ 00: Stack top address
.word PFA_COLD+1            @ 01: Reset Vector  +1 wegen des Thumb-Einsprunges

.word nullhandler+1   @ 02: NMI
.word faulthandler+1  @ 03: HARD fault
.word nullhandler+1   @ 04: MPU fault
.word nullhandler+1   @ 05: bus fault
.word nullhandler+1   @ 06: usage fault
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler+1   @ 11: SVCall handler
.word nullhandler+1   @ 12: Debug monitor handler
.word 0               @ 13: Reserved
.word nullhandler+1   @ 14: The PendSV handler
.word nullhandler+1   @ 15: systick handler
