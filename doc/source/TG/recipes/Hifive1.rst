.. _Hifive1:

=======
Hifive1
=======

An eval board from sifive.

Tools
-----

The easiest way to get working are the riscv packages in Ubuntu Bionic.
They come pre-configured and ready for use. Currently used version is
2.30.

.. code-block:: bash

   $ dpkg -l | grep risvc
     ii  binutils-riscv64-linux-gnu  2.30-20ubuntu2~18.04  

To upload the compiled binary, an risc-v enabled `openocd` and a special
`gdb` is needed. Both come from the `sifive.com <https://www.sifive.com/products/tools/>`__
website.

Board Setup
-----------

From the `Freedom E-SDK <https://github.com/sifive/freedom-e-sdk/tree/master/bsp/env>`_
download the whole freedom-e300-hifive1 directory and place it at ``risc-v/board/``

Application Setup
-----------------

Checkout amforth svn with at least rev. 2300. It contains an `appl/hifive1`
directory with the necessary files. place the binaries for `openocd` and `gdb`
somewhere in your `PATH` and call `make`.

The Makefile at `hifive/` can upload the hex file to the controller using `openocd`
and `gdb`.

.. code-block:: bash

   ~/amforth/appl/hifive$ make
   openocd -f ~/amforth/risc-v/board/freedom-e300-hifive1/openocd.cfg & \
   riscv64-unknown-elf-gdb ./amforth.hex --batch -ex "set remotetimeout 240" \
    -ex "target extended-remote localhost:3333" \
    -ex "monitor reset halt" \
    -ex "monitor flash protect 0 64 last off" \
    -ex "load" \
    -ex "monitor resume" \
    -ex "monitor shutdown" \
    -ex "quit" && \
   echo "Successfully uploaded 'amforth.hex' to freedom-e300-hifive1."
   Open On-Chip Debugger 0.10.0+dev-g2c183e3-dirty (2018-01-03-10:25)
   Licensed under GNU GPL v2
   For bug reports, read
       http://openocd.org/doc/doxygen/bugs.html
   adapter speed: 10000 kHz
   Info : auto-selecting first available session transport "jtag". To override use 'transport select <transport>'.
   Info : ftdi: if you experience problems at higher adapter clocks, try the command "ftdi_tdo_sample_edge falling"
   Info : clock speed 10000 kHz
   Info : JTAG tap: riscv.cpu tap/device found: 0x10e31913 (mfg: 0x489 (SiFive, Inc.), part: 0x0e31, ver: 0x1)
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=0
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=1
   Info : Examined RISCV core; XLEN=32, misa=0x40001105
   Info : Listening on port 3333 for gdb connections
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=2
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=3
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=4
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=5
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=6
   Info : dtmcontrol_idle=5, dbus_busy_delay=1, interrupt_high_delay=7
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=7
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=8
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=9
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=10
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=12
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=14
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=16
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=18
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=20
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=23
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=26
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=29
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=32
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=36
   Info : [0] Found 2 triggers
   halted at 0x204001a2 due to debug interrupt
   Info : Listening on port 6666 for tcl connections
   Info : Listening on port 4444 for telnet connections
   Info : accepting 'gdb' connection on tcp/3333
   Info : Found flash device 'issi is25lp128' (ID 0x0018609d)
   0x204001a2 in ?? ()
   Info : JTAG tap: riscv.cpu tap/device found: 0x10e31913 (mfg: 0x489 (SiFive, Inc.), part: 0x0e31, ver: 0x1)
   JTAG tap: riscv.cpu tap/device found: 0x10e31913 (mfg: 0x489 (SiFive, Inc.), part: 0x0e31, ver: 0x1)
   halted at 0x204001a2 due to debug interrupt
   halted at 0x204001a2 due to debug interrupt
   cleared protection for sectors 64 through 255 on flash bank 0
   cleared protection for sectors 64 through 255 on flash bank 0
   Info : JTAG tap: riscv.cpu tap/device found: 0x10e31913 (mfg: 0x489 (SiFive, Inc.), part: 0x0e31, ver: 0x1)
   halted at 0x204001a2 due to debug interrupt
   Loading section .sec1, size 0x59b4 lma 0x20400000
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=40
   Info : Retrying memory read starting from 0x80000000 with more delays
   Info : dtmcontrol_idle=5, dbus_busy_delay=2, interrupt_high_delay=45
   Info : Retrying memory read starting from 0x800000d8 with more delays
   halted at 0x80000004 due to software breakpoint
   halted at 0x80000004 due to software breakpoint
   halted at 0x80000004 due to software breakpoint
   halted at 0x80000004 due to software breakpoint
   halted at 0x80000004 due to software breakpoint
   Info : JTAG tap: riscv.cpu tap/device found: 0x10e31913 (mfg: 0x489 (SiFive, Inc.), part: 0x0e31, ver: 0x1)
   halted at 0x80000004 due to software breakpoint
   Start address 0x20400000, load size 22964
   Transfer rate: 56 KB/sec, 11482 bytes/write.
   shutdown command invoked
   shutdown command invoked
   A debugging session is active.
 
    Inferior 1 [Remote target] will be detached.

   Quit anyway? (y or n) [answered Y; input not from terminal]
   Remote communication error.  Target disconnected.: Die Verbindung wurde vom Kommunikationspartner zurückgesetzt.
   Successfully uploaded 'amforth.hex' to freedom-e300-hifive1.

This shall give the amforth prompt at the serial terminal. Sometimes the
openocd process does not terminate properly. Either kill it manually or start another
make upload to terminate it.

Features
--------

The serial command line uses 38400 8N1.

The RGB led is initialized at boot time and can be accessed with the color command
names ``red``, ``green``, ``blue``, ``white``, ``black`` and a few others.

There is a separate wordlist called `riscv-wordlist` that contains controller
specific words like CSR registers. Use ``riscv-wordlist show-wordlist`` to get 
a listing of the available words. The word ``@cycle`` returns a double cell number 
of the cpu cycles since boot.
