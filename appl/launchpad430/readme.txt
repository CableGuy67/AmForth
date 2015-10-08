Some notes on the amforth on the TI Stellaris Launchpad 430

       - not very structured so far -

It is a merge of camelforth 0.5a by Brad Rodriguez. His code
is highly modified and restructured. This is possible since
both forth's are very close to each other. The naken_asm
from Michael Kohn is used to create the hex file (any recent
version should do). The avrdude pendant is the mspdebug 
utility from the default repositories.

The primary goal is to explore the possibilities, the atmega
code base leads whenever it makes sense. A remote vision is to
have a single code base for all higer level code and the tools.

The MSP430 G2553 is used. It runs at 8MHz. The serial terminal
uses 9600/8N1 without flow control.

The MSP430 F5529 runs at 8MHz, the terminal uses 115200 (!) 8N1

A lot of the amforth features are already available:
- exceptions
- double cell numbers
- defers and values
- recognizers
- wordlists

Some features are not (fully) functional yet
- interrupts

Todo (major only)
- identify library and example code that works
  on both systems without modification. create
  portability libraries (csetb+cclrb vs portpin:)
