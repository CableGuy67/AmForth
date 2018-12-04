===
ARM
===

The ARM platform is a 32-bit system. Due to the very heterogenous systems
found here, only a small subset of boards may be usable at all.

Boot process
------------

Upon boot, the ARM core reads the first 2 words at address 0 and 4 
respectivly. The first number becomes the initial stack pointer
address, the second the initial PC address, effectivly the first 
address from which code is executed: The body of the word ``cold``.

``cold`` sets up the Forth VM inner interpreter and hands over to
``warm``. ``warm`` initialzes the remaining system including ``turnkey``
and finally calls ``quit`` which never returns and does the usual 
Forth command interpreter loop.

CPU -- Forth VM Mapping
-----------------------

The Forth VM has a few registers that need to be mapped to the
controller registers. 

.. _arm_register_mappings:

Register Mapping
................

+------------------------------+--------------------+
| Forth Register               | ARM Registers      |
+------------------------------+--------------------+
| W: Working Register          | r8                 |
+------------------------------+--------------------+
| IP: Instruction Pointer      | r9                 |
+------------------------------+--------------------+
| RSP: Return Stack Pointer    | r13 (sp)           |
+------------------------------+--------------------+
| PSP: Parameter Stack Pointer | r7                 |
+------------------------------+--------------------+
| UP: User Pointer             | r10                |
+------------------------------+--------------------+
| TOS: Top Of Stack            | r6                 |
+------------------------------+--------------------+
| loopsys (index+limit)        | r11 and r12        |
+------------------------------+--------------------+

The registers r0 to r5 are currently used as scratch
registers. The registers r4 and r5 are planned to be
used as extended VM registers.

Memory
------

The memory model is unified. All addresses are available with
the usual @/! words.

Strings are addr/len pairs. Since len is a cell sized number, the 
length is not really limited. Compiled strings however are limited 
to be usable with COUNT, that means up to 255 bytes in length.

The memory layout is defined primarily in ``preamble.inc``. It contains
the definitions for the stacks, the first user area and the terminal
input buffer. The dictionary contains further defintions that allocate
RAM. The first unused RAM address can be obtained with ``here``.

Dictionary
----------

The dictionary consists of two wordlists. One, :command:`forth-wordlist`
resides in flash memory and contains all standard words. The other one
called :command:`ram-wordlist` contains all user defined words. They both
are in the search order. The :command:`ram-wordlist` is the current
wordlist too.

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
   amforth 6.8 CORTEX-M LM4F120XL
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

   recipes/LM4F120XL

