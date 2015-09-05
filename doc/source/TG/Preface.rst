========
Overview
========

Amforth is a stand-alone Forth system for microcontrollers. Currently
the AVR ATmega micro controller family and some MSP430 types are
supported. It works on the controller itself and does not depend on 
any additional hard- or software. It places no restrictions on using
external hardware.

Amforth implements a large subset of the Forth standard Forth 2012
Most of the CORE and CORE EXT words and a varying number of words
from the other word sets are implemented. It is very easy to extend
or shrink the actual word list for a specific application by just
editing the dictionary include files.

The dictionary is located in the flash memory. The built-in
compiler extends it directly.

Amforth is published under the GNU General Public License
version 2.

The name amforth has no special meaning.

Amforth is a new implementation. The first code was written in
the summer of 2006 for Atmegas. It is written "from scratch" using 
assembly language and forth itself. In 2014 the MSP430 became possible
by merging major parts from Camelforth by Brad Rodrigues. Since then
both controller types share a lot of pre-assembled forth code in the
core system. In fact all high-level words like the interpreter are
common code.

