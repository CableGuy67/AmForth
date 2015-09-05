===========
First Steps
===========

The first steps require an ATmega micro controller or a
TI Launchpad 430 with a MSP430G2553 controller. The AVR
needs a separate RS232 connection to an PC, the MSP430 works
with the USB connection for both the command terminal and the
reprogramming. 

User Interface
--------------

amforth has a simple user interface. It is available as a serial
port.

.. code-block:: console

    > cold
    amforth 5.0 ATmega16 8000 kHz
    > words
    nr> n>r (i!) !i @i @e !e nip not s>d up! up@ ...
    >

Next Steps
----------

The next steps are performing some actions like LED on / off
and defining new commands to extent the interpreter. The
:ref:`Cookbook` has a lot of recipes for both.