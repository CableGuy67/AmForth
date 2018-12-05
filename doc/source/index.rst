
AmForth
=======

AmForth is an easily extendible command interpreter for the Atmel
AVR8 Atmega micro controller family and some variants of the
TI MSP430. The RISC-V CPU (32bit) is currently beeing worked on.
It has a turnkey feature for embedded use too.

AmForth is published under the GNU Public License v3 (GPL).
A commercial use is possible but for traditional commercial 
uses there are commercial Forths --- amForth just is not one 
of them.

AmForth runs completely on the controller. It does not need additional
hardware. It makes no restrictions for hardware extensions that can be
connected to the controller. The default command prompt is in a serial 
terminal.

The command language is `Forth <http://www.forth.org/tutorials.html>`_.
AmForth implements an almost compatible `Forth 2012 
<http://forth-standard.org/standard/words/>`_ indirect 
threading 16bit Forth. 

AmForth for the AVR8 needs 8 to 12 KB Flash memory, 80 bytes EEPROM, and 200 bytes
RAM for the core system. A similar code for the MSP430 fits into 8KB flash. The MSP430
info flash is used for similar purposes as the EEPROM for the AVR8 platform.

The 32-bit variants for ARM and RISC-V are experimental. They share high-level code
with the 16-bit variants.

Work In Progress
................

Here you'll find things that are not yet released but will be part of the next release.
See the code section at Sourceforge to get the
`most recent sources <http://sourceforge.net/p/amforth/code/HEAD/tree/trunk/>`__

* core(ARM32): new target ARM with 32bit word size using the Cortex M4 board 
  :ref:`LM4F120XL` TI Stellaris Launchpad.
* core(ARM32+RV32): compile to RAM, introducing the :command:`ram-wordlist` as target.
* core(AVR8): small fixes for bigger Atmegas. Thanks to Martin.
* core(RV32): numerous small improvements.

24.7.2018: release 6.7
.......................

* core(RV32): new target :ref:`Hifive1`, interpreter mode only.
* core(ALL): Fix some errors in :command:`accept` in corner cases. Thanks to Richard.

3.10.2017: release 6.6
.......................

* core(ALL): Update to Recognizer v4 keyword set.
* doc(ALL): Using `Gerald Wodni's <http://theforth.net/package/lcd-hd44780>`__
  module for :ref:`LCD HD44780`.
* core(ALL): new deferred prompt word :command:`.input`. :ref:`Prompts`
* core(AVR8): More work in interrupt reliability.
* core(ALL): factor :command:`(create-in)` (addr len wid --  ) to make a new 
  wordlist entry in a given wordlist without XT and data area.

30.4.2017: release 6.5
.......................

* core(AVR8): redesigned interrupt handling to improve reliability. Thanks to Erich.
* core(MSP430): highly experimental support for interrupt service routines in Forth
  for MSP430 2553. Manually enable it if your're brave the same way the AVR's work.
  :ref:`Interrupt Service Routine MSP430` and :ref:`Interrupt Service Routine`.

31.3.2017: release 6.4
.......................

* lib(ALL): :command:`((` for multiline comments. Comments end with :command:`))`.
  Uses recognizers for that from ``rec-double-paren.frt``.
* lib(AVR8): Implement :ref:`I2C Slave`. Renamed :command:`i2c.>n` to 
  :command:`i2c.n@` and :command:`i2c.n>` to :command:`i2c.n!`. :ref:`I2C Generic`
* lib(ALL): Recognizer for the Forth 2012 ``'c'`` Syntax to replace ``char c`` 
  and ``[char] c``. Just load the ``rec-char.frt`` file.
* core(AVR8): add :command:`>rx-buf (c -- )` that appends a character to the
  ring buffer that uses the usart receive interrupt.

More To Read
............

.. toctree::
   :maxdepth: 1

   UG/amforth_user
   faq
   TG/TG
   Projects/index
   TG/Cookbook
   Recognizers
   TG/refcard
   history
