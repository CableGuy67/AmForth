
# initial setup of assembly variables and settings

# used by ramallot
.set rampointer, RamStart  

.equ Zahlenpufferlaenge, 63 # Zahlenpufferlänge+1 sollte durch 4 teilbar sein !      Number buffer (Length+1 mod 4 = 0)
ramallot Zahlenpuffer, Zahlenpufferlaenge+1 # Reserviere mal großzügig 64 Bytes RAM für den Zahlenpuffer

  ramallot datenstackende, 256  # Data stack
  ramallot datenstackanfang, 0

  ramallot returnstackende, 256  # Return stack
  ramallot returnstackanfang, 0
