
AmForth
=======

AmForth is an easily extendible command interpreter for the Atmel
AVR8 Atmega micro controller family and some variants of the
TI MSP430. It has a turnkey feature for embedded use too.

AmForth runs completely on the controller. It does not need additional
hardware beyond a power supply. It makes no restrictions for hardware
extensions that can be connected to the controller.

The command language is `Forth <http://www.forth.org/tutorials.html>`_.
AmForth implements an almost compatible `ANS94 <http://forth.sourceforge.net/std/dpans/>`_
indirect threading 16bit Forth. There are some extensions from the
`Forth 2012 <http://www.forth200x.org/>`_ standard.

The interpreter has a command prompt in a serial terminal. Other
connections like TCP/IP telnet or radio links are possible.

AmForth is published under the GNU Public License v3 (GPL).

AmForth needs 8 to 12 KB Flash memory, 80 bytes EEPROM, and 200 bytes
RAM for the core system.

Karl Lunt has written an excellent :ref:`User Guide`
on how to start and work with AmForth. For those who want
to take a deeper look into the system is the :ref:`Technical Guide`.
The whole documentation is available as `PDF <amforth.pdf>`_
and `EPUB <AmForth.epub>`_.

.. raw:: html
  :file: html/leon-video.html

.. raw:: html
  :file: html/recognizers.html

Work In Progress
................

Here you'll find things that are not yet
released but will be part of the next release.
See the code section at Sourceforge to get the
`most recent sources <http://sourceforge.net/p/amforth/code/HEAD/tree/trunk/>`__

* core(ALL): :command:`name>interpret` and :command:`name>compile` added.
  New Recognizer :command:`rec:name` able to replace :command:`rec:word`. 
  Uses name tokens (Forth 2012) instead of execution tokens.
* core(MSP430): Lots of bugfixes. restructures the init process: :command:`cold` 
  now transfers the data from INFO flash back to RAM if BASE is set and 
  :command:`SAVE` was executed. That way the user code now correctly 
  survives a restart. :command:`SAVE` is much like marker that 
  overwrites the previous state and gets no name.

22.12.2014: release 5.6
.......................

* core(AVR): :command:`icompare` got the same return flag semantics as 
  :command:`compare`. The :command:`leave` and :command:`?do` forward branches
  are now resolved at compile time, saves one cell per loop on the return 
  stack at runtime.
* core(AVR): interrupt vectors are moved from RAM to EEPROM. Saves RAM space
  and simplifies turnkey actions (remove any ``int!`` from your turnkey!)
* core: re-arranged source files: controller specific and common code.
* New architecture: MSP430 (G2553) as used in the :ref:`TI_LaunchPad_430` 
  with code from `Camelforth <http://www.camelforth.com>`__ and 
  `4€4th <http://www.somersetweb.com/4E4th/EN.html>`__.
* core: generalized existing :ref:`Stacks` in EEPROM into :command:`map-stack`, 
  :command:`get-stack` and :command:`set-stack`. Used for the search order
  and recognizer stacks.
* all: changed license to GPLv3.

More To Read
............

.. toctree::
   :maxdepth: 1

   UG/amforth_user
   faq
   TG/TG
   TG/Cookbook
   TG/refcard
   history


