
.. _clockworks_ticks_main_crystal:

Generating Ticks from the main crystal
======================================

:Date: 2017-08-08

.. contents::
   :local:
   :depth: 1

Intro
-----

Since your favourite microcontroller board most likely has a crystal
as clock source already, we might just as well use it to generate
*ticks*.


Design Decisions
----------------

We always have to accept or make such decisions:

 * The main crystal has a baud rate compatible frequency of 11.059200
   MHz --- this is my favourite choice
 * For no particular reason, I decided to have ``32`` ticks/second. For
   reasons not yet apparent, a power of ``2`` is more suitable than
   other values.
 * We use timer/counter1, which is a 16-bit counter, to generate the
   ticks as timer overflow interrupts
 * We use the interrupt service routine to increment a variable

Any of the above values could be chosen otherwise.


Setting up Timer1 for overflow interrupts
-----------------------------------------

First we decompose the crystal frequency into its prime factors::

  11059200 = 2^14 * 3^3 * 5^2

Timer/Counter1 has a prescaler, which I chose to set to 256::

  11059200 = 256 * 2^6 * 3^3 * 5^2 = 256 * 43200

In order to have 32 timer overflows per second, we need to count this
number of cycles::

  11059200 = 256 * 32 * 2^1 * 3^3 * 5^2 = 256 * 32 * 1350

Timer/Counter1 will be used in CTC-Mode (clear on compare match). The
compare match value needs to be set to 1350-1 then. With only one
addition (toggle pin ``OC1A``) these things are to be found in the
function ``+ticks``.

.. code-block:: forth

   : +ticks
     ...
     \ --- timer1 ---
     [ %00000000                 \ WGM1[10] CTC mode
       %01000000 or              \ COM1A[10] toggle OC1A on compare match
     ] literal TCCR1A c!
     #1350 1-  OCR1A   !         \ TOP or compare match value rather
     DDRD c@ $80 or DDRD c!      \ pin OC2A output  
     [ %00000100                 \ CS1[210] clock_ts2/256
       %00001000 or              \ WGM1[32] CTC mode
     ] literal TCCR1B c! 
     ...
   ;


Toggling pin ``OC1A`` on timer/counter1 overflow is a means of
debugging: You can attach something (LED, buzzer, oscilloscope,
frequency counter, logic analyzer) to this pin in order to verify the
timers operation.

This exercise should hopefully motivate you to reread the data sheet
about timer/counter1. You may find that the prescaler does not provide
all powers of ``2``, just some. You may find quite a number of
different modes of operation. We chose *clear on compare match* mode,
which provides timer overflows after counting ``1350`` cycles. By
changing this compare value we could alter the length of the ticks.

Of course, one could choose 100 ticks/second, or something else. But
the crystal frequency, prescaler, and compare value need to be chosen
in such a way, that a number of ticks result in exactly one second (we
ignore the accuracy of the crystal at this stage).


Serving the Timer1 Overflow Interrupt
-------------------------------------

The timer/counter1 overflow interrupts do nothing so far, so we want
to add some effect to their occurance. This effect should be visible
in the running code somehow. The effect will be connected to the timer
overflow via the *interrupt service routine* ``tick_isr``.

.. code-block:: forth

  : tick_isr
    \ do something here
  ;

  : +ticks
    ...
    \ register ISR and enable OCIE1A interrupt
    ['] tick_isr TIMER1_COMPAAddr int!
    TIMSK1 c@ $02 or TIMSK1 c!
  ;

Now the ``do something here`` part needs to be considered. One could
set a bit flag in a variable, and upon serving this event in the main
program, the flag is being cleared. This would work in principle, but
we have not addressed possible race conditions. If the interrupt
setting the flag is called again before the last event has been
serviced, the second event is simply lost. If we spend only 1 bit of
information, we cannot count these events. So a variable as counter
may look more promising.

Incrementing a counter may not lose events, however, care must be
taken that the main programm and the interrupt do not produce
undesirable effects. Always keep in mind that the main program may be
interrupted at any time, even between reading two bytes of one
variable. So maybe its a bad idea, if the main program tries to
decrement the counter, unless we disable interrupts during that
operation.

Or maybe the main programm should only read the variable and never
write to it --- would that be better? But how about variable size and
the number of instructions needed to read its complete content? What
happens if the variable sooner or later wraps around?

**Welcome to the heart and core of making a software clock!**

Well, you can choose to abandon this project right here and run.
That would actually be ok!

Still reading? Well ...

I chose to increment variable ``ct.ticks`` from within the ISR. I also
think that we can't get it much simpler.
  
.. code-block:: forth

                : tick_isr   ( -- )      1 ct.ticks +! ;

The main program will use another variable ``ct.ticks.follow`` to keep
track of how many events it has serviced. Ideally the difference
should be ``0`` most of the time, and ``1`` after one interrupt has
occured. The main loop will check this difference as often as it can.

The variables will be 16 bit long for now. In order to deal with the
inevitable overflow a not so obvious comparison (``- 0<``) is used.

.. code-block:: forth

                : tick.over? ( -- t/f )  ct.ticks.follow @  ct.ticks @  - 0< ;

The difference between ``ct.ticks.follow`` and ``ct.ticks`` is
compared *less-or-equal-to-zero* as a signed quantity.

**Assignment #1:** *Verify that this code actually works (on paper, for
8 bit variables). Check that* ``0<`` *does not work correctly on 8 bit
variables (on the controller). Any idea why?*

The main programm acknowledges handling one event by incrementing
``ct.ticks.follow``.

.. code-block:: forth

                : tick.over! ( -- )      1 ct.ticks.follow +! ;


Putting it all together
-----------------------

We should find the above code snippets used in the main program
somehow like this (see e.g. :ref:`clockworks_main_fairly_minimal`).
Note that ``ticks`` is a separate variable in the main programm.

.. code-block:: forth

   include ewlib/clockticks_main_crystal.fs
   
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
         \ one tick over, do something
         1 ticks +!    \ count ticks
       then

       ticks @ 1+  ticks/sec > if
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

   \ 2017-08-13 ewlib/clock_tick1_main.fs
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
   
   #32 constant ticks/sec
   variable ct.ticks
   variable ct.ticks.follow
   variable last.tick[4]
   variable last.tick[5]
   
   \ overflow interupt service routine
   : tick_isr
     1 ct.ticks +!
   ;
   
   : tick.over? ( -- t/f ) ct.ticks.follow @  ct.ticks @  - 0< ;
   : tick.over! ( -- )     1 ct.ticks.follow +! ;
   
   \ enable ticks
   \ crystal:   11059200 /sec
   \ prescaler: 256
   \            43200 /sec
   \ TOP+1:     1350
   \            32 /sec
   : +ticks
     0 ct.ticks        !
     0 ct.ticks.follow !
     0 last.tick[4]    !
     0 last.tick[5]    !
   
     \ --- timer1 ! ---
     [ %00000000                 \ WGM1[10] CTC mode
       %01000000 or              \ COM1A[10] toggle OC1A on compare match
     ] literal TCCR1A c!
     #1350 1-  OCR1A   !         \ TOP or compare match value rather
     DDRD c@ $80 or DDRD c!      \ pin OC2A output  
     [ %00000100                 \ CS1[210] clock_ts2/256
       %00001000 or              \ WGM1[32] CTC mode
     ] literal TCCR1B c! 
                                 \ register isr
     ['] tick_isr TIMER1_COMPAAddr int! 
     TIMSK1 c@ $02 or TIMSK1 c!  \ enable OCIE1A interupt
   ;
   
   : -ticks
     TIMSK1 c@
     [ $02 invert ] literal
     and TIMSK1  c!              \ disable OCIE1A interrupt
     $00  TCCR1B c!              \ disable timer/counter1
     $02  TIFR2  c!              \ clear interrupt flags
   ;
   
   \ no phase shift accumulator
   \ one second == 32 ticks
   \ half second == 16 ticks
   \ that is a toggle on bit 4 of ct.ticks.follow
   : half.second.over? ( -- 0|1|2 )
     \ return: 0 == false
     \         1 == half second over
     \         2 == second over
     ct.ticks.follow c@
     $0010 and 0= 0=  \ extract significant bit as t/f
     dup last.tick[4] @ = if
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
       ( sig.bit-t/f ) last.tick[4] !
     then
   ;
   
   : second.over? ( -- t/f )
     ct.ticks.follow c@  $0020 and 0= 0=
     dup  last.tick[5] @  = if
       drop 0
     else
       last.tick[5] !
       -1
     then
   ;
