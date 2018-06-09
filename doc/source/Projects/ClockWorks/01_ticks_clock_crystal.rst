.. _clockworks_ticks_clock_crystal:

Generating Ticks from an additional clock crystal
=================================================

:Date: 2017-08-07

.. contents::
   :local:
   :depth: 1


Intro
-----

Our favorite microcontroller features two pins to use an external
clock crystal at 32768 Hz to drive timer/counter2. We use its
overflows to generate *ticks*, moreover we could put the
microcontroller to sleep between these events, if needed.


Design Decisions
----------------

 * Timer/counter2 is driven asynchronouosly at 32768 Hz
 * Timer/counter2 is an 8-bit counter, counting 256 cycles unless
   instructed otherwise
 * So we get ``128`` ticks/second::

     32768/256 = 128

 * prescaler offers dividers of 8, 32, 64, 128, 256, 1024; with these
   values we could also generate 16, 4, 2 , 1, 1/2, 1/4 ticks/second.

 * in addition we could set CTC mode (*clear counter on compare
   match*) and choose the compare value. So for example setting the
   prescaler to ``8`` and the compare match value to ``128-1`` we
   should get ``32`` ticks/second again.


Setting up Timer2 for asynchronous operation
--------------------------------------------

We set up timer/counter2 in *normal mode*, it will count ``256`` clock
cycles and then issue an overflow interrupt. Then we switch the clock
source to the external clock crystal via asynchronuos mode.

.. code-block:: forth

   : +ticks
     ...
     [ %00000000                 \ normal mode
     ] literal TCCR2A c!
     [ %00000001                 \ 001 = clock_ts2, prescaler 1
     ] literal TCCR2B c!
     ASSR_AS2 ASSR  c!           \ clock source: 32 kiHz crystal
     ...
   ;

**TODO:** add toggling an output pin for debug!



Serving Timer2 overflow interrupts
----------------------------------


Similar to the code explained in the section
:ref:`clockworks_ticks_main_crystal`, the ISR increments variable
``ct.ticks``. The main loop will acknowledge the effect by
incrementing ``ct.ticks.follow``.


.. code-block:: forth

   \ timer overflow ISR
   : tick2_isr ( -- )  1 ct.ticks +! ;

   : +ticks    ( -- )
     ...
     ['] tick2_isr TIMER2_OVFAddr int!
     TIMSK2 c@ $01 or TIMSK2 c!  \  enable OVF2 interupt
   ;

   variable ct.ticks
   variable ct.ticks.follow

   : tick.over? ( -- t/f ) ct.ticks.follow @  ct.ticks @  - 0< ;
   : tick.over! ( -- )     1 ct.ticks.follow +! ;


Putting it all together
-----------------------

We should find the above code snippets used in the main program
somehow like this:

.. code-block:: forth

   include ewlib/clockticks_clock_crystal.fs

   variable ticks
   : init
     ...
     0 ticks !
     +ticks
   ;

   : run-loop
     init
     begin
       tick.over? if
         tick.over!
         \ one tick over, do someting
         1 ticks +!    \ count ticks
       then

       second.over? > if
         ticks @ ticks/sec - ticks !
         \ one second over, do something!
         ...
       then

     again
   ;



The Code
--------

.. code-block:: forth
   :linenos:

   \ 2017-03-27 EW   ewlib/clock_tick2_clockcrystal.fs
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

   #128 constant ticks/sec
   variable ct.ticks
   variable ct.ticks.follow
   variable last.tick[6]
   variable last.tick[7]


   \ timer 2 overflow interrupt service routine
   : tick2_isr
     1 ct.ticks +!
   ;

   : tick.over? ( -- t/f ) ct.ticks.follow @  ct.ticks @  - 0< ;
   : tick.over! ( -- )     1 ct.ticks.follow +! ;


   \ enable ticks
   \ crystal:   32768 /sec
   \ clock src: 32768 /sec
   \ overflow:  32768/256 = 128 /sec
   : +ticks
     0 ct.ticks         !
     0 ct.ticks.follow  !
     0 last.tick[6]     !
     0 last.tick[7]     !

     \ --- timer2 ---
     [ %00000000                   \ normal mode
     ] literal TCCR2A c!
     [ %00000001                   \ 001 = clock_ts2
     ] literal TCCR2B c!
     ASSR_AS2 ASSR  c!             \ source: 32 kiHz crystal
     ['] tick2_isr TIMER2_OVFAddr int! \ register ISR
     TIMSK2 c@ $01 or TIMSK2 c!    \  enable OVF2 interupt
   ;

   \ disable ticks
   : -ticks
     TIMSK2 c@
     [ $01 invert ] literal
     and TIMSK2  c! ( clr Timer 2 )
     $00  ASSR   c!
     $00  TCCR2B c!
     $07  TIFR2  c! \ clear interrupt flags, jibc
   ;


   \ one second == 128 ticks
   \ half second == 64 ticks
   \ that is a toggle on bit 6 of ct.ticks.follow
   : half.second.over? ( -- 0|1|2 )
     \ return: 0 == false
     \         1 == half second over
     \         2 == second over
     ct.ticks.follow c@
     $0040 and 0= 0=  \ extract significant bit as t/f
     dup last.tick[6] @ = if
       \ no change, done
       drop 0
     else
       dup 0= if
         \ falling edge, second over
         2
       else
         \ rising edge, half second over
         1
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
