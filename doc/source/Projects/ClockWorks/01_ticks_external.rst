.. _clockworks_ticks_external:

Generating Ticks from an external clock source
==============================================

:Date: 2017-08-08

.. contents::
   :local:
   :depth: 1
       
Intro
-----

Of course, we can delegate the task of providing a highly stable clock
signal to an external component, such as the DS3231 clock chip
featuring a TCXO (*temperature compensated crystal oscillator*).

While exploring why my clock was somehow slow, among a lot of other
things I came across the DS3231 chip. It features an i2c-interface, a
clock, an onboard TCXO, and on top a pin providing a highly stable
32768 Hz clock signal. This square wave clock signal can be used to
generate ticks by collecting it on pin ``T0`` or ``T1`` and using
timer/counter0,1 as a counter.

While this is not exactly a *minimal* addition to the clock (nor was
it exactly cheap), it solves two problems at once:

 #. When equipped with a backup battery or supercap, it will keep the
    time even when no power is provided to the microcontroller board.

 #. It can provide a considerably more accurate clock source than the
    crystals mentioned in the other sections on generating ticks. This
    is why a TCXO is a highly desirable feature.

With both of these features, regular adjustment of the clock or
numerical compensation of some frequency offset drop significantly in
their importance. There is more that this chip can provide, e.g. an
alarm repeating once per second, thus providing a 1 or 1/2 Hz square
wave signal.


Design Decisions
----------------

 * We use the 32768 Hz square wave of DS3231 as clock signal for the
   software clock on the microcontroller

 * The clock signal is collected on pin ``T0`` and fed into
   timer/counter0, the falling edge is the beginning of a cycle.

 * We run timer/counter0 in *normal mode*, it will count 256 clock
   cycles to overflow and thus produce 128 ticks/second::

     32768/256 = 128
   
 * I chose to artificially reduce the variables ``ct.ticks2`` and
   ``ct.ticks2.follow`` to 8 bit rather than 16. This needs an 8-bit
   version of ``0<`` as well, namely ``c0<``

 * For purely aestetic reasons (switching off an led after 1/2 second)
   I also chose to implement a new function ``half.second.over?``,
   which is called in the main programm.
   

Setting up Timer0 for overflow interrupts
-----------------------------------------

There should be no surprises in function ``+ticks``. We need to
configure pin ``T0`` as highZ-input pin.

.. code-block:: forth

   : +ticks0
     ...
     [
       %00000000                        \ OC.A,B off, normal mode
     ] literal TCCR0A c! 
     [
       %00000110                        \ ext. clocksource on T0, falling edge
     ] literal TCCR0B c!
   
     DDRA  c@ $01 invert and DDRA  c!   \ pin T0 input
     PORTA c@ $01 invert and PORTA c!   \ + low  => highZ
     ...
   ;
                

**TODO:** add a debug pin???



Serving the Timer0 Overflow Interrupt
-------------------------------------

The interrupt service routine called on timer overflow is incrementing
a counter, as we have seen in the other sections about generating
ticks. There is one additional feature here: I chose to ignore the
high byte of the counter and thus handle it like a 8-bit variable.
This is more of a leftover from hunting lost interrupt events (which
turned out to be a race condition in AmForth and is fixed since
version 6.5) than anything else. But I decided to leave it in for your
inspiration.

.. code-block:: forth

   variable ct.ticks
   variable ct.ticks.follow
   \ 8bit counters!
   : c0<         ( n n -- t/f )  >< 0< ;
   : tick.over?  ( -- t/f )      ct.ticks.follow c@  ct.ticks c@  - c0< ;
   : tick.over!  ( -- )          ct.ticks.follow c@  1+  ct.ticks.follow c! ;

   : tick0_isr
     ct.ticks c@ 1+  ct.ticks c!           \ 8bit counter
   ;
                
   : +ticks
     0           ct.ticks         !
     0           ct.ticks.follow  !
     ...
     ['] tick0_isr TIMER0_OVFAddr int!     \ register isr
     TIMSK0 c@ $01 or TIMSK0 c!            \ enable timer0 overflow interrupt
   ;



Counting Ticks: half seconds and seconds
----------------------------------------

So far I have left the decision of whether a second has completed to
the main programm alltogether. This is not a difficult task, but I
would like to use something different here. In the main program I want
to know, whether a second has completed, or just half a second (since
the last full one). So the function ``half.second.over?`` returns
``2``, if a second has completed, ``1`` if only half a second has
completed, and ``0`` else.

In order to determine the answer I look at Bit 6 in
``ct.ticks.follow``. We know that ``128`` ticks per second are
expected. After ``64`` cycles, bit 6 toggles in the counter. This is
independant of the fact that the counter was limited to 8 bit. It
would work equally well with a variable using 16 bit. If bit 6 toggles
from ``0`` to ``1``, the half a second has passed. After a full
second, this bit toggles back from ``1`` to ``0``.

.. code-block:: forth

   variable last.tick0[6]
   
   : half.second.over? ( -- 0|1|2 )
     \ return: 0 == false
     \         1 == half second over
     \         2 == second over
     ct.ticks.follow c@
     $0040 and 0= 0=    \ extract significant bit as t/f
     dup last.tick0[6] @ = if
       drop 0           \ no change, done
     else
       dup 0= if
         2              \ falling edge, second over
       else
         1              \ rising edge, half second over
       then
       swap
       ( sig.bit-t/f ) last.tick0[6] !
     then
   ;


I did the same trick on bit ``7`` to determine if a second has passed.
This leads to a simpler version of ``second.over?``, if needed.

   
Putting it all together
-----------------------

.. code-block:: forth

   include ewlib/clockticks_external.fs
   
   : odd?  ( x -- t/f )  $0001 and 0= 0= ;
   : even? ( x -- t/f )  $0001 and 0= ;

   : init
     ...
     +ticks
   ;

   : run-loop
     init
     begin
       tick.over? if
         tick.over!
         \ one tick over, do something
         ...
       then

       half.second.over?
       dup 0<> if
         dup odd? if       \ half second
           \ ... switch led.1 off
         else              \ second
           \ ... switch led.1 on
           \ do something
         then
       then
       drop

     again
   ;
         
   




The Code
--------

.. code-block:: forth
   :linenos:

   \ 2017-03-27 EW   ewlib/clock_tick0_external.fs
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
   \ words:
   \        +ticks    register and enable interupt
   \        -ticks    disable interupt
   
   #128 constant ticks/sec
   variable ct.ticks
   variable ct.ticks.follow
   variable last.tick[6]
   variable last.tick[7]
   
   \ ct.ticks is used as 8-bit counter (not 16-bit)
   : c0<        ( -- )     >< 0< ;
   : tick.over? ( -- t/f ) ct.ticks.follow c@  ct.ticks c@  - c0< ;
   : tick.over! ( -- )     ct.ticks.follow c@  1+  ct.ticks.follow c! ;
   
   : tick_isr
     ct.ticks c@ 1+  ct.ticks c!
   ;
   
   \ enable ticks
   \ ext.clock: 32768 /sec
   \ overflow:  32768/256 = 128 /sec =^= 7.8125 milli-sec ticks
   : +ticks
     0 ct.ticks         !
     0 ct.ticks.follow  !
     0 last.tick[6]     !
     0 last.tick[7]     !
     
     [
       %00000000                           \ OC.A,B off, normal mode
     ] literal TCCR0A c! 
     [
       %00000110                           \ ext. clocksource on T0, falling edge
     ] literal TCCR0B c!
   
     \ pin T0 input, low = highZ?
     DDRA  c@ $01 invert and DDRA  c!      \ pin T0 input
     PORTA c@ $01 invert and PORTA c!      \ + low  => highZ
   
     ['] tick_isr TIMER0_OVFAddr int!      \ register interupt service routine
     
     TIMSK0 c@ $01 or TIMSK0 c!            \ timer0 overflow int. enable
   ;
   
   \ disable ticks
   : -ticks
     TIMSK0 c@ $01 invert and TIMSK0 c!    \ disable timer0 ovf int
     $00  TCCR0B c!
     $07  TIFR0  c!                        \ clear interrupt flags, jibc
   ;
   
   \ one second == 128 ticks
   \ half second == 64 ticks
   \ that is a toggle on bit 6 of ct.ticks.follow
   : half.second.over? ( -- 0|1|2 )
     \ return: 0 == false
     \         1 == half second over
     \         2 == second over
     ct.ticks.follow c@
     $0040 and 0= 0=                       \ extract significant bit as t/f
     dup last.tick[6] @ = if
       drop 0                              \ no change, done
     else
       dup 0= if
         2                                 \ falling edge, second over
       else
         1                                 \ rising edge, half second over
       then
       swap
       ( sig.bit-t/f ) last.tick[6] !
     then
   ;
   
   : second.over? ( -- t/f )
     ct.ticks.follow c@  $0080 and 0= 0=
     dup  last.tick[7] @  = if
       drop 0
     else
       last.tick[7] !
       -1
     then
   ;
                
