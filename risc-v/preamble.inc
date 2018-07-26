
# initial setup of assembly variables and settings

# used by ramallot
.set rampointer, RamStart  
.set dppointer,FlashStart

.set userpointer, 0

.set sys_userarea_size, 32

.set userarea_size, sys_userarea_size+appl_userarea_size

ramallot datastack, datastack_size
ramallot returnstack, returnstack_size
ramallot refill_buf, refill_buf_size
ramallot userarea, userarea_size
