Author:
    Matthias Trute <mtrute@users.sourceforge.net>
    died 2020-03-25

Maintainer:
    2020-     Erich Wälde <erwaelde@users.sourceforge.net>

Major Contributors:
    Erich Waelde
    Michael Kalus
    Leon Maurer
    Ullrich Hoffmann
    Karl Lund
    Enoch
    Bradford Rodriguez (MSP430 code from Camelforth 0.5)
    Matthias Koch (RV32IM + ARM Code from mecrisp)
    Tristan Williams

License: General Public License (GPL) Version 3 from 2007. See the
file LICENSE.txt or http://www.gnu.org/licenses/gpl.html. This
license applies to all files unless a file has some different
attribution in it.

AmForth is an interactive Forth for various controllers
It does not need additional hard or software. It works 
completely on the controller (no cross-compiler). AmForth 
uses the indirect threading forth implementation technique.

ATmega:

  Wordsize is 16bit. The forth dictionary is in the flash memory, new 
  words are compiled directly into flash. Since no (widely available) 
  bootloader supports an API to write to flash, AmForth uses the 
  bootloader space itself.

MSP430
  
  Wordsize is 16bit. The Forth dictionary is in the flash or FRAM memory, 
  new words are compiled to it. Use SAVE to keep the code accessible across
  reboots. The flash devices cannot rewrite the flash cell once a 
  word is written.

RV32IM
  Wordsize is 32bit. Uses a unified memory model.

ARM Cortex-M
  Wordsize is 32bit. Uses a unified memory model

AmForth is implemented in assembly and Forth. The code is stable
and well tested. The 32bit variante are newer and may have less
features.

All words have Forth 2012 (CORE and various extenion word sets)
stack diagrams, but not necessarily the complete semantics. Some
words from the standards are left out, ask for them if you need them.

Development hardware are evaluation boards running various Controllers
with various external hardware: none, led, push-buttons, SD-card, 
ethernet controller, RF module etc. 

Documentation can be found in the doc/ subdirectory and
on the homepage http://amforth.sourceforge.net/.

Contact, bug reports, questions, wishes etc:
    mailto:amforth-devel@lists.sourceforge.net
