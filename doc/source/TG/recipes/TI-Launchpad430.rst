.. _TI_Launchpad_430:

Texas Instruments LaunchPad 430
===============================

Texas Instruments has the MSP430 microcontroller
familiy. It is completely different to the AVR
Atmegas. Amforth recently started to support it
as well. The Forth kernel is (almost) the same,
many tools like the amforth-shell work for both
too. Since the MSP430 is new, bugs and other oddities
are more likely than for the Atmegas.

The sources are made for the 
`naken_asm <http://www.mikekohn.net/micro/naken_asm.php>`__
assembler. 

Playing with the Launchpad
--------------------------

The LEDs can be used as follows

.. code-block:: forth

   : red:init   1 34 bm-set ;
   : red:on     1 33 bm-set ;
   : red:off    1 33 bm-clear ;
   : green:init 64 34 bm-set ;
   : green:on   64 33 bm-set ;
   : green:off  64 33 bm-clear ;


Example for (machine) code (instead of 
the forth code above)

.. code-blocK:: forth

   code red:init  $D3D2 , $0022 , end-code
   code red:on  $D3D2 , $0021 , end-code
   code red:off $C3D2 , $0021 , end-code

There are many ways to wait, e.g. do other
things while waiting (`PAUSE`). A simple 
approach is do nothing:

.. code-blocK:: forth
 
   : ms 0 ?do 1ms loop ;                                                         

Now let the red LED blink ONCE

.. code-blocK:: forth

   : blink red:on 100 ms red:off 100 ms ;                                          

Test it! Now! The compiled version is *much* 
faster than the sequence "1 33 bm-set 1 33 bm-clear"
(watch the red flashes). Next is to let it blink until 
a key is pressed

.. code-blocK:: forth

   : blink-forever begin blink key? until key drop ;                                        

A big difference to the AVR's is that amforth for the MSP430
needs an explicit :command:`save` command to make all writes
to the dictionary permanent. Otherwise every changes are lost
at :command:`cold` or reset and moreover a re-flash is necessary.

Hardware Setup
--------------

At the first glance, the hardware setup is trivial:
Connect your Launchpad to the USB port of your PC.
It may take a while until the modem manager detects
that it is not a device it can handle. Now open a 
terminal (I use minicom) and set the serial port 
settings: `/dev/acm0`, 9600 and 8N1 without flow 
control.



MSP430 G2553
............

The mspdebug to actually program the controller uses
the rf2500 protocol:

.. code-block:: bash

   > mspdebug rf2500 "prog launchpad430.hex "
    MSPDebug version 0.22 - debugging tool for MSP430 MCUs
    Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Trying to open interface 1 on 007
    rf2500: warning: can't detach kernel driver: No data available
    Initializing FET...
    FET protocol version is 30394216
    Set Vcc: 3000 mV
    Configured for Spy-Bi-Wire
    fet: FET returned error code 4 (Could not find device or device not supported)
    fet: command C_IDENT1 failed
    Using Olimex identification procedure
    Device ID: 0x2553
      Code start address: 0xc000
      Code size         : 16384 byte = 16 kb
      RAM  start address: 0x200
      RAM  end   address: 0x3ff
      RAM  size         : 512 byte = 0 kb
    Device: MSP430G2xx3
    Number of breakpoints: 2
    fet: FET returned NAK
    warning: device does not support power profiling
    Chip ID data: 25 53
    Erasing...
    Programming...
    Writing  424 bytes at 0200...
    Writing  188 bytes at 1000...
    Writing 4096 bytes at e000...
    Writing 4008 bytes at f000...
    Writing   32 bytes at ffe0...
    Done, 8748 bytes total

Your Amforth terminal session (minicom) should now print some readable
characters like

.. code-block:: none

   +-------------------------------------
   | amforth 5.6 MSP430G2553 8000 kHz 
   | >
   |

Thats all. If nothing has happened look for error messages
in the mspdebug window. Try replugging the launchpad. Some
more information are in the :ref:`TI-Raspberry` recipe.

You can reprogram the controller via USB whilst the terminal
session is still active. In this case you'll see repeated 
welcome strings from amforth due to some resets.

.. code-block:: none

   +-------------------------------------
   | amforth 5.6 MSP430G2553 8000 kHz 
   | > amforth 5.6 MSP430G2553 8000 kHz 
   | > amforth 5.6 MSP430G2553 8000 kHz 
   | > amforth 5.6 MSP430G2553 8000 kHz 
   | > amforth 5.6 MSP430G2553 8000 kHz 
   | >
   |


MSP430 F5529 & FR5969
.....................

Thess chips require the libmsp430.so from TI which is (at least
with ubuntu) *not* part of the mspdebug package. I used the one
from `Energia <https://s3.amazonaws.com/energiaUS/energia-0101E0016-linux64.tgz>`__
and copied it into :file:`/usr/lib`.

.. code-block:: bash

   $ mspdebug tilib "prog amforth-5529.hex"
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   tilib: can't find libmsp430.so: libmsp430.so: cannot open shared object file: No such file or directory

If the following error message is displayed

.. code-block:: bash

   tilib: MSP430_Initialize: Interface Communication error (error = 35)

the modem manager is still using the serial port. Just wait for it.

The next error message is potentially more troublesome

.. code-block:: bash

   mspdebug tilib "prog amforth-5529.hex"
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   MSP430_GetNumberOfUsbIfs
   MSP430_GetNameOfUsbIf
   Found FET: ttyACM0
   MSP430_Initialize: ttyACM0
   FET firmware update is required.
   Re-run with --allow-fw-update to perform a firmware update.
   tilib: device initialization failed

Now you have to update the programming module on the launchpad. Be aware
that this is a potentially dangerous action, it may seem to brick the 
chip (if not, you're lucky) if something goes wrong:

.. code-block:: bash
 
   $ mspdebug tilib --allow-fw-update
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   MSP430_GetNumberOfUsbIfs
   MSP430_GetNameOfUsbIf
   Found FET: HID_FET
   MSP430_Initialize: HID_FET
   FET firmware update is required.
   Starting firmware update (this may take some time)...
   tilib: MSP430_FET_FwUpdate: MSP-FET / eZ-FET recovery failed (error = 73)
   tilib: device initialization failed

In this case try running the command as root e.g. via sudo

.. code-block:: bash

   $ sudo mspdebug tilib --allow-fw-update 
   [sudo] password for <user>: 
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   MSP430_GetNumberOfUsbIfs
   MSP430_GetNameOfUsbIf
   Found FET: HID_FET
   MSP430_Initialize: HID_FET
   FET firmware update is required.
   Starting firmware update (this may take some time)...
   Initializing bootloader...
   Programming new firmware...
     0 percent done
    34 percent done
    67 percent done
   100 percent done
   Update complete
   Done, finishing...
   MSP430_VCC: 3000 mV
   tilib: MSP430_VCC: Internal error (error = 68)
   tilib: device initialization failed

The error 68 signals "ok, I'm almost done". Now re-run the same command to
finally do the firmware update. Note some subtle differences in the
output like the HID_FET vs. ttyACM0.

.. code-block:: bash

   $ sudo mspdebug tilib --allow-fw-update 
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   MSP430_GetNumberOfUsbIfs
   MSP430_GetNameOfUsbIf
   Found FET: ttyACM0
   MSP430_Initialize: ttyACM0
   FET firmware update is required.
   Starting firmware update (this may take some time)...
   Initializing bootloader...
   Programming new firmware...
     4 percent done
    20 percent done
    36 percent done
    52 percent done
    68 percent done
    84 percent done
   100 percent done
   Update complete
   Done, finishing...
   MSP430_VCC: 3000 mV
   MSP430_OpenDevice
   MSP430_GetFoundDevice
   Device: MSP430F5529 (id = 0x0030)
   8 breakpoints available
   MSP430_EEM_Init
   Chip ID data: 55 29 18

   Available commands:
     =           erase       isearch     power       save_raw    simio       
     alias       exit        load        prog        set         step        
     break       fill        load_raw    read        setbreak    sym         
     cgraph      gdb         md          regs        setwatch    verify      
     delbreak    help        mw          reset       setwatch_r  verify_raw  
     dis         hexout      opt         run         setwatch_w  

   Available options:
     color                       gdb_loop                    
     enable_bsl_access           gdbc_xfer_size              
     enable_locked_flash_access  iradix                      
     fet_block_size              quiet                       
     gdb_default_port            

   Type "help <topic>" for more information.
   Use the "opt" command ("help opt") to set options.
   Press Ctrl+D to quit.

   (mspdebug) <Ctrl-D> 
   MSP430_Run
   MSP430_Close

If done properly the actions looks as follows

.. code-block:: bash

   $ sudo mspdebug tilib --allow-fw-update 
   MSPDebug version 0.22 - debugging tool for MSP430 MCUs
   Copyright (C) 2009-2013 Daniel Beer <dlbeer@gmail.com>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   MSP430_GetNumberOfUsbIfs
   MSP430_GetNameOfUsbIf
   Found FET: ttyACM0
   MSP430_Initialize: ttyACM0
   FET firmware update is required.
   Starting firmware update (this may take some time)...
   Initializing bootloader...
   Programming new firmware...
     75 percent done
     84 percent done
     84 percent done
     91 percent done
     96 percent done
     99 percent done
    100 percent done
    100 percent done
   Initializing bootloader...
   Programming new firmware...
      4 percent done
     20 percent done
     36 percent done
     52 percent done
     68 percent done
     84 percent done
    100 percent done
   Update complete
   Done, finishing...
   MSP430_VCC: 3000 mV
   MSP430_OpenDevice
   MSP430_GetFoundDevice
   Device: MSP430FR5969 (id = 0x012d)
   3 breakpoints available
   MSP430_EEM_Init
   Chip ID data: 69 81 30

   Available commands:
     =           erase       isearch     power       save_raw    simio       
     alias       exit        load        prog        set         step        
     break       fill        load_raw    read        setbreak    sym         
     cgraph      gdb         md          regs        setwatch    verify      
     delbreak    help        mw          reset       setwatch_r  verify_raw  
     dis         hexout      opt         run         setwatch_w  

   Available options:
     color                       gdb_loop                    
     enable_bsl_access           gdbc_xfer_size              
     enable_locked_flash_access  iradix                      
     fet_block_size              quiet                       
     gdb_default_port            

   Type "help <topic>" for more information.
   Use the "opt" command ("help opt") to set options.
   Press Ctrl+D to quit.

   (mspdebug)  <Ctrl-D>
   MSP430_Run
   MSP430_Close

Now your hardware is configured to upload the hexfiles from amforth

.. code-block:: bash

   $ mspdebug tilib "prog amforth-5529.hex"

giving the amforth command prompt in your serial terminal

.. code-block:: forth

   amforth 6.1 MSP430F5529 8000 kHz
   > words                        
   key? key emit? emit ...
