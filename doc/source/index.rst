
AmForth
=======

AmForth is an easily extendible command interpreter for the Atmel
AVR8 Atmega micro controller family and some variants of the
TI MSP430. It has a turnkey feature for embedded use too.

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

Work In Progress
................

Here you'll find things that are not yet released but will be part of the next release.
See the code section at Sourceforge to get the
`most recent sources <http://sourceforge.net/p/amforth/code/HEAD/tree/trunk/>`__

* core(MSP430): Use the hardware multiplier if available. Add :command:`n>r` and :command:`nr>`.
* lib(ALL): Chains: Lists of execution tokens. 
* core(ALL): The three prompt words are now system USER based defers: :command:`.ready` for the >,
  :command:`.error` if an error occured and :command:`.ok` if everything was fine. See :ref:`prompts`
  for more.

4.7.2016: release 6.2
.....................

* core+lib(MSP430): New optional assembly (compile-time) words :command:`d2*` and :command:`d2/`.
* core(ALL): renamed :command:`find-name ( addr len -- xt +/-1 | 0)` to :command:`find-xt`, compare to
  :command:`find-name ( addr len --  nt|0)` to deal with name tokens.
* core(MSP430): add :command:`pause` to the usart IO words.
* core(ALL): complete recognizer `Rev. 3 </pr/Recognizer-rfc-C.pdf>`__ adaption.

17.10.2015: release 6.1
.......................

* core(ALL): Adapt :command:`postpone` action of the recognizers to comply with
  `Rev. 3 </pr/Recognizer-rfc-C.pdf>`__. Change your recognizers accordingly.
* core(MSP430): New devices MSP430 F5529 (Flash) and FR5969 (FRAM). See :ref:`TI_Launchpad_430`.
* core(MSP430): Extended VM Register A. See :ref:`Extended-VM`
* lib(ALL): Fix regressions in :command:`Rdefer` and :command:`does>`. 
  Make quotations more robust in corner cases.

6.9.2015: release 6.0
......................

* core(ALL): Fix a few regressions like the TAB handling in :command:`accept`.
* core(AVR8): Fix :command:`forth-wordlist` to return a valid wordlist id.
* core(MSP430): many small changes to bring it closer to the AVR8. Still fits into 8KB flash.

  * global variables like :command:`DP` (:command:`HERE`), :command:`STATE`, :command:`HLD` 
    etc instead of USER variables-
  * Same USER area layout. Including deferred words for terminal IO.
  * complete wordlist support including search order and current.
  * Emulate AVR EEPROM configuration with a info flash segment. Needs :command:`save` to
    store the data permantly.
  * Lots of common code, optimized versions of standard words if applicable.
  * preparing for more MSP430 device types.


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
