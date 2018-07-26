
# initial setup of assembly variables and settings

# used by ramallot
.set rampointer, RamStart  
.set dppointer,FlashStart

ramallot datastack, datastack_size
ramallot returnstack, returnstack_size
ramallot refill_buf, refill_buf_size

