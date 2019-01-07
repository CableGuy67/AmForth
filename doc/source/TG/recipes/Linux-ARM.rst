.. _Linux-ARM:

Linux-ARM
=========

The ARM variant can be configured to run under Linux as
a ordinary program. This means that it does not run bare-metal.
It depends on a running Linux kernel and the whole Linux
environment.

Currently working environments are the raspberry pi (v3 tested)
and the qemu-arm emulator on a x64 PC system.

Note that the terminal does echos of the input. Disable this with
`stty -icanon -echo` but expect side effects. Re-enable the default
settings with `stty sane`.

Building
--------

The ``appl/linux-arm`` directory is the starting point.

On ative ARM linux environments the binutils are sufficient.

Cross-Building from a PC requires the `binutils-linux-gnueabi` package 
from the standard Ubuntu 18.04 repository. Other platforms may work 
too.

Note the difference to the `binutils-none-eabi` package for the
:ref:`LM4F120XL` microcontroller board.

Running
-------

just call amforth on a raspberry pi in a terminal

.. code-block:: shell

   $ uname -mso
   Linux armv7l GNU/Linux
   $ ./amforth
   amforth 6.8 Linux armv7l rpi
   Type CTRL-D or CTRL-C to exit
   > 

On a PC the qemu-arm-static emulates what the raspberry pi provides

.. code-block:: shell

   $ qemu-arm-static ./amforth
   amforth 6.8 Linux armv7l ayla
   Type CTRL-D or CTRL-C to exit
   > 

If the qemu-user-static package is installed and configured, the system
autodetects the ARM target inside the amforth binary and calls the
qemu-arm-static automatically:

.. code-block:: shell
  
   $ uname -mso
   Linux x86_64 GNU/Linux
   $ file ./amforth
   ./amforth: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), 
     statically linked, not stripped
   $ ./amforth
   amforth 6.8 Linux armv7l ayla
   Type CTRL-D or CTRL-C to exit
   > 

The welcome banner changes with the architecture (armv71) and the
hostname according to the uname data from Linux.
