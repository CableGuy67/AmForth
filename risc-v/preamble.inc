
# initial setup of assembly variables and settings

# used by ramallot
.set rampointer, RamStart  

.equ Zahlenpufferlaenge, 63 # Zahlenpufferlänge+1 sollte durch 4 teilbar sein !      Number buffer (Length+1 mod 4 = 0)
ramallot Zahlenpuffer, Zahlenpufferlaenge+1 # Reserviere mal großzügig 64 Bytes RAM für den Zahlenpuffer

.equ datastack_size, 128
.equ returnstack_size, 128
.equ refill_buf_size, 128

  ramallot datastack, 128 
  ramallot returnstack, 128
  ramallot refill_buf, 128
