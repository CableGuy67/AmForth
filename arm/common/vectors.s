
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
.word nullhandler+1

nullhandler:
   push {lr}
   mrs r1, ipsr

   adds r1, #48 @ "0"
   SEMIT r1

   pop {pc}

faulthandler:
   push {lr}

   mrs r1, ipsr
   adds r1, #48 @ "0"
   SEMIT r1

   ldr r1, =#64
   SEMIT r1

   pop {pc}

.ltorg


@ Special interrupt handlers for this particular chip:

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word 0  @ 25: Reserved
.word 0  @ 26: Reserved
.word 0  @ 27: Reserved
.word 0  @ 28: Reserved
.word 0  @ 29: Reserved

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word nullhandler+1   @ 34: Watchdog timers 0 and 1

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave

.word nullhandler+1   @ 41: Analog Comparator 0
.word nullhandler+1   @ 42: Analog Comparator 1

.word 0  @ 43: Reserved

.word nullhandler+1   @ 44: System Control (PLL, OSC, BO)
.word nullhandler+1   @ 45: FLASH Control

.word nullhandler+1


.word 0  @ 47: Reserved
.word 0  @ 48: Reserved
.word nullhandler+1   @ 49:
.word nullhandler+1   @ 50:
.word nullhandler+1   @ 51:
.word nullhandler+1   @ 52:
.word nullhandler+1   @ 53:
.word 0  @ 54: Reserved
.word nullhandler+1   @ 55:
.word 0  @ 56: Reserved
.word 0  @ 57: Reserved
.word 0  @ 58: Reserved
.word nullhandler+1   @ 59:
.word nullhandler+1   @ 60:
.word 0  @ 61: Reserved

.word nullhandler+1   @ 62:
.word nullhandler+1   @ 63:
.word nullhandler+1   @ 64:
.word nullhandler+1   @ 65:
.word nullhandler+1   @ 66:
.word nullhandler+1   @ 67:

.word 0  @ 68: Reserved
.word 0  @ 69: Reserved
.word 0  @ 70: Reserved
.word 0  @ 71: Reserved
.word 0  @ 72: Reserved

.word nullhandler+1   @ 73:
.word nullhandler+1   @ 74:
.word nullhandler+1   @ 75:
.word nullhandler+1   @ 76:
.word nullhandler+1   @ 77:
.word nullhandler+1   @ 78:
.word nullhandler+1   @ 79:

.word 0  @ 80: Reserved
.word 0  @ 81: Reserved
.word 0  @ 82: Reserved
.word 0  @ 83: Reserved

.word nullhandler+1   @ 84:
.word nullhandler+1   @ 85:
.word nullhandler+1   @ 86:
.word nullhandler+1   @ 87:

.word 0  @ 88: Reserved
.word 0  @ 89: Reserved
.word 0  @ 90: Reserved
.word 0  @ 91: Reserved
.word 0  @ 92: Reserved
.word 0  @ 93: Reserved
.word 0  @ 94: Reserved
.word 0  @ 95: Reserved
.word 0  @ 96: Reserved
.word 0  @ 97: Reserved
.word 0  @ 98: Reserved
.word 0  @ 99: Reserved
.word 0  @ 100: Reserved
.word 0  @ 101: Reserved
.word 0  @ 102: Reserved
.word 0  @ 103: Reserved
.word 0  @ 104: Reserved
.word 0  @ 105: Reserved
.word 0  @ 106: Reserved
.word 0  @ 107: Reserved

.word nullhandler+1   @ 108:
.word nullhandler+1   @ 109:
.word nullhandler+1   @ 110:
.word nullhandler+1   @ 111:
.word nullhandler+1   @ 112:
.word nullhandler+1   @ 113:
.word nullhandler+1   @ 114:
.word nullhandler+1   @ 115:
.word nullhandler+1   @ 116:
.word nullhandler+1   @ 117:
.word nullhandler+1   @ 118:
.word nullhandler+1   @ 119:
.word nullhandler+1   @ 120:
.word nullhandler+1   @ 121:
.word nullhandler+1   @ 122:

@ 123-154 reserved, space can be used for core instead.

