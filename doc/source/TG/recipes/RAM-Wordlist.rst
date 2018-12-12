.. _RAM-Wordlist:

RAM Wordlist
============

It is a wordlist that is stored in RAM. At resets all content
is lost. The :ref:`ARM` and :ref:`RISC-V` versions use it as
the default compilation target. The :ref:`AVR8` does not
support it due to hardware restrictions, the :ref:`MSP430`
does not yet have one.

.. code-block:: forth

   > : hi! ." hi!" ;
    ok
   > ram-wordlist show-wordlist
   hi! ok
   > cold
    amforth 6.8 ...
   > ram-wordlist show-wordlist
    ok
   >

Exceptions do not wipe the wordlist.
