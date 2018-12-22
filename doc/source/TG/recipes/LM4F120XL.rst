.. _LM4F120XL:

=========
LM4F120XL
=========

An older (2013) TI Launchpad board. 

The CPU is a LM4F120H5QR 32-bit ARM Cortex M4F running at 80MHz. 
It has 256 kB flash memory and 32 kB SRAM.


Tools
-----

Ubuntu 18.04 provides all necessary tools in the packages
``binutils-arm-none-eabi`` and ``lm4flash``. All steps required
to build and upload the code is in the ``launchpad-arm/Makefile``. 
Just run ``make clean && make && make upload`` in one go.

Flashing the binary requires root privileges. See
`lm4tools <https://github.com/utzig/lm4tools>`__ for a
solution.

Features
--------

The RGB led is initialized and can be controlled with commands like ``red`` 
or ``black`` (turns it off).

.. code-block:: forth

   > red \ turns on the red LED
    ok
   > cyan blue yellow white
    ok
   > black \ essentially turns off the LED
    ok
   >

The CPU contains a timer that can be used for hardware assisted delays. It may
be started in the ``turnkey`` action and runs independently. The millisecond wait
loop calls the word ``pause`` internally to make the multitasker happy. The loop
terminates as soon as the minimum time is expired. This way, the actual delay 
may be slightly longer.

.. code-block:: forth

   > delay-init
    ok
   > 1000 ms \ waits 1 second
    ok 
   > 400000 us \ waits 400.000 microseconds
    ok
   >

Basic flash write words are available: 

  * ``!i`` ( n addr -- )
    stores n at addr, with repeated writes to the same address 
    only bit changes from 1 to 0 are done.
  * ``c!i`` ( n addr -- )
    stores a single byte at addr. Same restrictions as ``!i``
  * ``w!i`` ( n addr -- )
    stores a 16-bit number at addr. Same restrictions as ``!i``
  * ``flashpageerase`` ( addr -- )
    erases the 1KB flash page at addr

Access to the data stored provide the usual ``@`` and ``c@`` operations.
