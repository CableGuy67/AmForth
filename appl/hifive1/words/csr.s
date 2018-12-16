

CSR 0x000, ustatus
CSR 0x004, uie
CSR 0x005, utvec
CSR 0x040, uscratch
CSR 0x041, uepc
CSR 0x042, ucause
CSR 0x042, ubadaddress

CSR 0x300, mstatus
CSR 0x301, misa
CSR 0x342, mcause

CSR 0xb00, mcycle
CSR 0xb80, mcycleh

COLON "@cycle", FETCH_CYCLE
  .word XT_CSR_mcycle
  .word XT_CSR_mcycleh
  .word XT_EXIT
