
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

* New architecture: MSP430 (G2553) with code from 
  `Camelforth <http://www.camelforth.com>`__. Use 
  it only if you're brave.
* core: re-arranged source files.
* core: changed license to GPLv3.
* core: generalized existing :ref:`Stacks` in EEPROM into :command:`map-stack`, 
  :command:`get-stack` and :command:`set-stack`. Used for the search order
  and the recognizer stacks.

6.10.2014: release 5.5
......................

* core: Bugfix in :command:`warm` to initialize the interpreter for 
  :command:`turnkey`. Thanks to David.
* core: bugfixes for handling some negative numbers in :command:`+loop` 
  and :command:`*/`.
* core: simplified assembly primitves for counted loops. They are
  now faster except for :command:`i`. The return stack gets different
  numbers now.
* core: rewrite of :command:`accept`. The user visible change is that the final CR/LF
  is no longer sent here. The forth text interpreter does it elsewhere thus
  the user interface is unchanged.
* core: Fixed a regression introduced after 5.1: a<b is not always the same 
  as a-b<0.

16.8.2014: release 5.4
......................

* lib: Almost complete :ref:`Blocks` wordset support. Only a few dark corners behave differently.
* lib: renamed TWI to I2C, added many tools for it :ref:`I2C Values`, :ref:`I2C EEPROM Blocks` and 
  a few more.
* recipes: `Test Driven Development <http://en.wikipedia.org/wiki/Test-driven_development>`_ 
  with :ref:`Amforth <Testing>`, :ref:`Conditional Interpret`
* lib: Fully support the ANS94 String wordset.
* core: Double cell return stack access words (:command:`2>r` and 
  :command:`2r>`) missed the internal swap's. Added new :command:`2r@`.
* lib: Limited LOCALs

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


