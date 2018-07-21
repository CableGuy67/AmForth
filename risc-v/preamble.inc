
# initial setup of assembly variables and settings

# used by ramallot
.set rampointer, RamStart  

.equ datastack_size, 128
.equ returnstack_size, 128
.equ refill_buf_size, 96

  ramallot datastack, datastack_size
  ramallot returnstack, returnstack_size
  ramallot refill_buf, refill_buf_size

