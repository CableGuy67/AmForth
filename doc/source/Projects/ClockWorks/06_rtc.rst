.. _clockworks_rtc:

Adding a RTC (battery backed)
=============================

:Date: 2017-08-19

.. contents::
   :local:
   :depth: 1

Intro
-----

A battery (or SuperCAP) backed RTC (real time clock) keeps track of
time, even if the clock lacks power. Obviously that is a nice thing to
have, and obviously this will work only as long as the backup storage
of energy provides any.

There is a multitude of such clocks, I have used only two of them:

 #. PCF8583 (Philips)
 #. DS3231 (Dallas Semiconductors)

Both feature a i2c bus interface.


Code Details
------------

i2c bus
^^^^^^^

AmForth provides sufficient support for the i2c bus (called two wire
interface (twi) in Atmel lingo). So we just need to load it:

.. code-block:: forth

   #include i2c-twi-master.frt
   #include i2c.frt
   #include i2c-detect.frt


The last file provides a command to scan the bus, helpful while
debugging. We then add a function to set the i2c interface up to our
liking:

.. code-block:: forth

   PORTC 0 portpin: i2c_scl
   PORTC 1 portpin: i2c_sda

   : +i2c  ( -- )
     i2c_scl pin_pullup_on
     i2c_sda pin_pullup_on
     0                                     \ prescaler
     #6                                    \ bit rate --- 400kHz @ 11.0592 MHz
     i2c.init
   ;

The exact numbers for ``prescaler`` and ``bit rate`` must be
calculated according to the atmega data sheet. I also added my own
function to scan the bus --- just the output looks different.

.. code-block:: forth

   : i2c.scan
     base @ hex
     $79 $7 do
       i i2c.ping? if i 3 .r then
     loop
     base !
     cr
   ;



BCD digits
^^^^^^^^^^

Probably for historical reasons, the information provided by these
RTCs is encoded in *binary code decimal* format. I have written 2
words to convert the data at hand. These will fail with numbers
larger than ``99`` --- you have been warned!

.. code-block:: forth

   : bcd>dec  ( n.bcd -- n.dec )               $10 /mod  #10 * + ;
   : dec>bcd  ( n.dec -- n.bcd )     #100 mod  #10 /mod  $10 * + ;



:doc:`PCF8583 <06_rtc_pcf8583>`
-------------------------------

This clock provides a subsecond counter, namely 1/100 th of a second.
However, this clock does not provide the year any better than ``year
modulo 4``. This is the absolute minimum to keep track of leap year
--- with occasional errors (3 times in 400 years).

The speed of this clock can be slowed down by adding load capacitors
(a few picofarad) to its clock crystal.



:doc:`DS3231 <06_rtc_ds3231>`
-----------------------------

This clock provides a `temperature compensated crystal oscillator`, a
32768 Hz clock output. The year counter provides ``year modulo 100``,
which gives a wrong leap year only once in 400 years.




