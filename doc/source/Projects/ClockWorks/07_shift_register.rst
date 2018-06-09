.. _clockworks_shift_register:

Accessing Shift Registers
=========================

:Date: 2017-08-18

.. contents::
   :local:
   :depth: 1


Intro
-----

Driving LEDs or 7-Segment Registers can be done in several ways. This
document explains, how to interface them with shift registers. A shift
register will receive 8 bit of data on a connection with 2 signals:
data and clock. After the complete byte has been transfered, a third
signal, latch, can be used to assert the newly received byte on the
corresponding 8 output pins. A shift register is, in a way, a serial
to parallel converter. Interestingly, shift registers can be chained.

For example, one can transfer 4 Bytes through a chain of 4 shift
register chips. After the transfer asserting the latch signal will
make the transfered bytes appear on all the output pins
simultaneously.

I strongly prefer shift registers and thus continuous signals on LEDs
over the multiplexing (and thus flickering) methods.


Code Details
------------

We need to define 3 pins corresponding to the acutal hardware layout:

.. code-block:: forth

   \ abakus display
   PORTD 2 portpin: sr_latch
   PORTD 3 portpin: sr_clock
   PORTD 4 portpin: sr_data

Then ``+sr`` will set the pins up correctly (never assume that pins
are setup in a specific way before you start using them):

.. code-block:: forth

   : +sr  
     sr_latch pin_output  sr_latch high
     sr_clock pin_output  sr_clock low
     sr_data  pin_output  sr_data  high
   ;


``bit>sr`` will clock out just one bit and nothing else:

.. code-block:: forth

   : bit>sr ( bit -- )
     if sr_data high else sr_data low then
     sr_clock high  sr_clock low
   ;


The shift registers I use expect the most significant bit first. This
could be otherwise. So ``byte>sr`` clock out one byte. The loop can be
written differently, of course.

.. code-block:: forth

   : get.bit ( byte pos -- bit )
     1 swap lshift    \ -- byte bitmask
     and              \ -- bit
   ;

   \ clock one byte out, MSB first!
   : byte>sr ( byte -- )
     0 7 do
       dup i get.bit   \ 7 6 5 ... 0: MSB first!
       bit>sr
     -1 +loop
     drop
   ;
   

So far data is transfered, but not asserted onto the output pins.
So ``>sr`` adds asserting a low pulse on pin latch:

.. code-block:: forth

   : >sr
     byte>sr
     sr_latch low sr_latch high
   ;




Putting it all together
-----------------------

The main program will know, how many shift registers are chained (if
any), thus a function like ``n>sr`` will be needed: clock out a known
number of bytes, then assert the latch signal.

.. code-block:: forth

   : n>sr  ( c1 .. cn n -- )
     0 ?do
       byte>sr
     loop
     sr_latch low sr_latch high
   ;



The Code
--------

.. code-block:: forth
   :linenos:

   \ 2017-05-10 shiftregister.fs
   \
   \ Written in 2017 by Erich Wälde <erich.waelde@forth-ev.de>
   \
   \ To the extent possible under law, the author(s) have dedicated
   \ all copyright and related and neighboring rights to this software
   \ to the public domain worldwide. This software is distributed
   \ without any warranty.
   \
   \ You should have received a copy of the CC0 Public Domain
   \ Dedication along with this software. If not, see
   \ <http://creativecommons.org/publicdomain/zero/1.0/>.
   \
   \
   \ needs pin definitions
   \     PORTD 2 portpin: sr_latch
   \     PORTD 3 portpin: sr_clock
   \     PORTD 4 portpin: sr_data
   \ words:
   \     +sr ( -- )     \ enable shift register
   \     emit.sr ( n -- )     \ transfer 1 Byte
   \     type.sr ( xn-1 .. x0 n -- )  \ n Bytes
   
   : +sr  
     sr_latch pin_output  sr_latch high
     sr_clock pin_output  sr_clock low
     sr_data  pin_output  sr_data  high
   ;
   
   : bit>sr ( bit -- )
     if sr_data high else sr_data low then
     sr_clock high  sr_clock low
   ;
   
   : get.bit ( byte pos -- bit )
     1 swap lshift    \ -- byte bitmask
     and              \ -- bit
   ;
   
   \ clock one byte out, MSB first!
   : byte>sr ( byte -- )
     0 7 do
       dup i get.bit
       bit>sr
     -1 +loop
     drop
   ;


