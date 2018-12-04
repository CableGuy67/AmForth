======
RISC-V
======

Boot process
------------

Upon boot, the CPU starts at address 0x20400000. There is a jump
instruction into the body of ``cold``. ``cold`` sets up the Forth 
VM inner interpreter and hands over to ``warm``. ``warm`` initialzes 
the remaining system including ``turnkey`` and finally calls ``quit`` 
which never returns and does the usual Forth command interpreter loop.


CPU -- Forth VM Mapping
-----------------------

The Forth VM has a few registers that need to be mapped to the
controller registers. 

.. _riscv_register_mappings:

Register Mapping
................

+------------------------------+--------------------+
| Forth Register               | RISC-V Register    |
+------------------------------+--------------------+
| W: Working Register          | x17                |
+------------------------------+--------------------+
| IP: Instruction Pointer      | x16                |
+------------------------------+--------------------+
| RSP: Return Stack Pointer    | x2 (sp)            |
+------------------------------+--------------------+
| PSP: Parameter Stack Pointer | x4                 |
+------------------------------+--------------------+
| UP: User Pointer             | x18                |
+------------------------------+--------------------+
| TOS: Top Of Stack            | x3                 |
+------------------------------+--------------------+
| loopsys (index+limit)        | x8 and x9          |
+------------------------------+--------------------+

The registers x5 to r7 and x10 to x15 are currently used 
as scratch registers. The registers x20 and x21 are planned 
to be used as extended VM registers.

Memory
------

The memory model is unified. All addresses are available with
the usual @/! words.

Strings are addr/len pairs. Since len is a cell sized number, the 
length is not really limited. Compiled strings however are limited 
to be usable with COUNT, that means up to 255 bytes in length.

Dictionary
----------

The dictionary consists of three wordlists. One, ``forth-wordlist``
resides in flash memory and contains all standard words. The other one
called ``ram-wordlist`` contains all user defined words. The third
wordlist ``csr`` has definitions for controller specific words and 
constants. Only the first two wordlists are part of the standard search order.
The ``ram-wordlist`` is the current wordlist for new definitions too.

Upon reset all words from the ram-wordlist are erased.

.. code-block:: forth

   > : foo ; 
   ok
   > ram-wordlist show-wordlist
   foo ok
   > : bar ;
   ok
   > ram-wordlist show-wordlist
   foo bar ok
   > cold
   amforth 6.8 RV32IM 
   > ram-wordlist show-wordlist
   ok
   >

Exceptions like -13 for not-found keep this wordlist intact however.

Environment
-----------

The environment information are listed in the wordlist ``environment``.
The usual sequence ``s" /pad" ?environment`` can be rewritten as
``s" /pad" environment search-wordlist drop execute``, assuming that
the environment query actually exists.


.. toctree::
   :maxdepth: 1

   recipes/Hifive1
