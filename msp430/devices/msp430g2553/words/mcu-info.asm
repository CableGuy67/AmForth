ENVIRONMENT(XT_ENV_MCU_INFO,8,"mcu-info")
    .DW XT_DOLITERAL
    .dw mcuinfo
    .DW XT_EXIT
mcuinfo:
    ; first fixed sized elements
    .dw RAMEND-RAMSTART ; RAM Size
    ; last Element with variable length
mcu_name:
	.db 11,"MSP430G2553"
