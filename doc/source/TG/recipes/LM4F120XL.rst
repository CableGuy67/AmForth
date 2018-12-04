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

