.. _clockworks_main_utc_wallclock:

Model 3: The UTC Wall Clock
===========================

:Date: 2017-09-18

.. contents::
   :local:
   :depth: 1


Design Decisions
----------------

 * 128 ticks/sec, generated from external RTC clock (32768 Hz)
 * uptime counter
 * multitasker
 * a battery backed real time clock is connected via i2c
 * start time is read from RTC
 * **new:** RTC generates 32768 Hz signal to drive clock ticks
 * **new:** run epoch seconds as additional software clock
 * **new:** use epoch seconds to derive times in 3 different time
   zones, read desired zone from 2 input pins
 * **new:** conversion to and from epoch seconds: additional
   ``.short`` versions use cached values for some epoch, e.g. 2017
 * **new:** shift register drives 7-segment digits as display


Description
-----------

The code included below is a complete, working example, tested on an
atmega644p controller. The syntax for the includes is such that
``amforth-shell.py`` will upload the programm and resolve all
``#include file`` directives.

This clock is a more traditional design with 4 large 7-Segment digits
and a good RTC (battery backed). Placed in a nice housing it can be
used standalone.


.. figure:: i_model3_2.jpg
   :width: 600 px

   **Model 3:** Four 7-segment LED digits to indicate local time.


The **Pinout** section should be familiar by now. Using quotations
(``[: ... ;]``) the LED definitions can have alias names, which might
be more useful in the given context.

The **Display** is driven by shift registers as before. These are
connected to 7-segment digits, not individual LEDs.

Time zones are selected by reading 2 pins.

The **Real Time Clock** is a different chip (:doc:`DS3231
<06_rtc_ds3231>`). It needs somewhat adapted functions to read and set
the time counters. The chip is much more accurate than the clock
sources I have used before.

The counters of the master clock are unchanged, uptime is counted as
before. The :doc:`source <01_ticks_external>` of the **clock tick**
has changed. The 32768 Hz square wave signal is driving timer/counter0
which overflows 128 times per second. The corresponding interrupt
service routine increments a counter, the main loop checks whether a
half second has passed.

:doc:`Functions <06_rtc_ds3231>` to set/read/display the counters of
the master clock are available. Functions to copy time counter values
from between the master clock and the RTC follow.

Handling of time zones, epoch seconds, and the display of a local time
are handled as described in section :doc:`Time Zones <08_timezones>`.

:doc:`Multitasking <04_multitasking>`,
:doc:`periodic jobs <03_periodic_jobs>`,
a background task to run the main loop of
the master clock --- everything is as described before (:doc:`Model 2
<41_main_clock_abakus>`).


.. figure:: p_display_wallclock2.png

   **Schematic** for one 7-segment digit


.. figure:: i_model3_1.jpg
   :width: 600 px

   **Prototype Board** manually worked

.. figure:: i_model3_3.jpg
   :width: 600 px

   **Controller Board** and display


The Code
--------

.. code-block:: forth
   :linenos:
   :emphasize-lines: 16-19

   \ 2017-08-30  main-20-utc-wallclock.fs
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
   \ include syntax for upload with amforth-shell.py
   \
   \     11.059200 MHz main crystal
   \     32768 Hz square signal on pin T0
   \     timer/counter0
   \     128 ticks/second
   \
   \ minimal clock
   \ plus i2c, i2c RTC (ds3231)
   \      display: shift registers (TPIC 6B595) and 4 7-segment digits
   \      MasterClock in UTC, display in 2 other timezones
   \      2 pins for selection of timezone

   #include erase.frt
   #include bitnames.frt
   #include marker.frt
   \ these definitions are resolved by amforth-shell.py as needed
   \ include atmega644p.fs

   #include flags.frt
   #include 2variable.frt
   #include 2constant.frt
   #include 2-fetch.frt
   #include 2-store.frt
   #include m-star-slash.frt
   #include quotations.frt
   #include avr-defers.frt
   #include defers.frt
   #include eallot.frt
   #include 2evalue.frt

   marker --start--

   PORTA $03 bitmask: _tz

   \ PORTB 0 portpin: T0
   \ PORTB 1 portpin: T1
   PORTB 2 portpin: led.0
   PORTB 3 portpin: led.1
   PORTB 4 portpin: led.2
   PORTB 5 portpin: led.3
   : led_dcf  [: led.0 ;] execute ;
   : led_utc  [: led.1 ;] execute ;
   : led_mez  [: led.2 ;] execute ;
   : led_mesz [: led.3 ;] execute ;

   PORTC 0 portpin: i2c_scl
   PORTC 1 portpin: i2c_sda

   \ abakus/4x7seg display
   PORTD 4 portpin: sr_data
   PORTD 5 portpin: sr_clock
   PORTD 6 portpin: sr_latch
   \ --- famous includes and other words
   : ms   ( n -- )       0 ?do pause 1ms loop ;
   : u0.r ( u n -- )     >r 0 <# r> 0 ?do # loop #> type ;
   : odd?  ( x -- t/f )  $0001 and 0= 0= ;
   : even? ( x -- t/f )  $0001 and 0= ;

   \ --- driver: status leds
   #include leds.fs

   \ --- driver: time zone switch
   : +sw ( -- )          _tz pin_input ;

   \ --- driver: i2c rtc clock
   : bcd>dec  ( n.bcd -- n.dec )
     $10 /mod  #10 * + ;
   : dec>bcd  ( n.dec -- n.bcd )
     #100 mod  #10 /mod  $10 * + ;

   #include i2c-twi-master.frt
   #include i2c.frt
   #include i2c-detect.frt
   : +i2c  ( -- )
     i2c_scl pin_pullup_on
     i2c_sda pin_pullup_on
     i2c.prescaler/1
     #6 \ bit rate --- 400kHz @ 11.0592 MHz
     i2c.init
   ;

   : i2c.scan
     base @ hex
     $79 $7 do
       i i2c.ping? if i 3 .r then
     loop
     base !
     cr
   ;
   $68 constant i2c_addr_rtc
   #2000 constant Century
   #include i2c_rtc_ds3231.fs

   \ --- master clock
   \ --- timeup
   #include timeup_v0.0.fs
                                           \ tu.counts -- fields available as:
                                           \   tick sec min hour day month year
                                           \ last_day_of_month ( year month -- last_day )
                                           \ timeup.init
                                           \ timeup
                                           \ tu.upd.limits ( Y m -- )

   \ --- uptime
   2variable uptime
   : .uptime  ( -- )  uptime 2@  decimal ud. [char] s emit ;
   : ++uptime ( -- )  1.  uptime 2@  d+  uptime 2! ;

   \ --- timer0 clock tick
   \ 128 ticks/sec
   \ timer_0_ overflow
   \ clock source pin T0 @ 32768 Hz (from ds3231)
   #include clock_tick0_external.fs

                                           \ +ticks
                                           \ tick.over?  ( -- t/f )
                                           \ tick.over!
                                           \ half.second.over?  ( -- 0|1|2 )
   : clock.set ( Y m d H M S -- )
     sec ! min ! hour !
     1- day !
     over over
     1- month ! year !
     ( Y m ) tu.upd.limits
   ;
   : clock.get ( -- S M H d m Y )
     sec @ min @ hour @
     day @ 1+ month @ 1+ year @
   ;
   : clock.dot ( S M H d m Y -- )
     #4 u0.r [char] - emit #2 u0.r [char] - emit #2 u0.r  [char] _  emit
     #2 u0.r [char] : emit #2 u0.r [char] : emit #2 u0.r
   ;
   : clock.show ( -- )
     clock.get
     clock.dot
   ;

   : .date
     year  @    4 u0.r
     month @ 1+ 2 u0.r
     day   @ 1+ 2 u0.r
   ;
   : .time
     hour @ 2 u0.r [char] : emit
     min  @ 2 u0.r [char] : emit
     sec  @ 2 u0.r
   ;

   : hwclock>clock ( -- )
     rtc.get    \ -- sec min hour wday day month year
        year  !
     1- month !
     1- day   !
     ( wday ) drop
        hour  !
        min   !
        sec   !
     year @   month @ 1+  tu.upd.limits
   ;
   : clock>hwclock ( -- )

     year @   month @ 1+  day @ 1+
     1 \ sunday ":-)
     hour @   min   @     sec @
     ( Y m d wday H M S ) rtc.set
   ;

   #include shiftregister.fs
   #include 7seg_1.fs

   \ --- epoch seconds, timezones
   : u>= ( n n -- t/f ) u< invert ;
   : d>s ( d -- n ) drop ;
              variable   _last_epoch
             2variable   _last_esec

   #2017        Evalue   EE_last_epoch
   #1483228800. 2Evalue  EE_last_esec \ 2017

   #include epochseconds.fs
   2variable Esec
   : ++Esec  ( -- )  Esec 2@  1. d+  Esec 2! ;
   : .Esec   ( -- )  Esec 2@ ud. ;

   2variable EsecOffset
   : UTC  ( -- )     0. EsecOffset 2! ;
   : MEZ  ( -- )  3600. EsecOffset 2! ;
   : MESZ ( -- )  7200. EsecOffset 2! ;
   : _tz.set
     _tz pin@
     dup 0 = if
       UTC
       led_utc on  led_mez off led_mesz off
     then
     dup 1 = if
       MEZ
       led_utc off led_mez on  led_mesz off
     then
     dup 2 = if
       MESZ
       led_utc off led_mez off led_mesz on
     then
     dup 3 = if
       UTC
       led_utc on  led_mez off led_mesz off
     then
     drop
   ;

   : local.dt ( -- S M H d m Y )
     Esec 2@  EsecOffset 2@  d+  s>dt.short
   ;
   : cd.localtime
     local.dt          \ -- S M H d m Y
     drop drop drop    \ -- S M H
     rot drop swap     \ -- H M
     >r #10 /mod swap  \ -- H.10 H.1
     r> #10 /mod swap  \ -- H.10 H.1 M.10 M.1
     #4 type.7seg      \ --
   ;

   \ --- multitasker
   #include multitask.frt
   : +tasks  multi ;
   : -tasks  single ;


   \ --- timeup jobs ---------------------------
   : job.tick
   ;
   : job.sec
     ++uptime
     ++Esec
   ;
   : job.min
     _tz.set cd.localtime
   ;
   : job.hour  ;
   : job.day   ;
   : job.month
     \ update length of month in tu.limits
     year @  month @ 1+  tu.upd.limits
   ;
   : job.year  ;

   create Jobs
     ' job.tick ,
     ' job.sec , ' job.min ,   ' job.hour ,
     ' job.day , ' job.month , ' job.year ,

   variable jobCount
   : jobCount++
     jobCount @
     6 < if
       1 jobCount +!
     then
   ;

   \ --- task 2 --------------------------------
   : run-masterclock
     ['] tx-poll to emit \ add emit to run-masterclock
     begin

       tick.over? if
         tick.over!
         1 tick +!
         job.tick
       then

       half.second.over?
       dup 0<> if
         dup odd? if       \ half second
           led.1 off
         else              \ second
           led.1 on
           timeup
           0 tick !
           1 jobCount !
         then
       then
       drop

       \ run one job per loop, not all at once
       jobCount @
       bv tu.flags fset?
       if
         jobCount @ dup
         Jobs + @i execute
         bv tu.flags fclr
       then
       jobCount++

       pause
     again
   ;
   $40 $40 0 task: task-masterclock \ create task space
   : start-masterclock
     task-masterclock tib>tcb
     activate
     \ words after this line are run in new task
     run-masterclock
   ;
   : starttasker
     task-masterclock task-init            \ create TCB in RAM
     start-masterclock                     \ activate tasks job

     onlytask                              \ make cmd loop task-1
     task-masterclock tib>tcb alsotask     \ start task-2
     multi                                 \ activate multitasking
   ;

   \ --- main ----------------------------------
   : init
     +sr
     $00 byte>sr $00 byte>sr $00 byte>sr $00 byte>sr
     sr_latch low sr_latch high
     +sw
     +leds leds-intro
     #2017 1 1 0 0 0 clock.set
     0. uptime 2!
     0. Esec    2!
     EE_last_epoch _last_epoch  !
     EE_last_esec  _last_esec  2!
     +ticks
     timeup.init
     +i2c
     i2c_addr_rtc i2c.ping? if
       hwclock>clock
       clock.get ut>s.short Esec 2!
     else
       _last_epoch @ 1 1 0 0 0 clock.set
       _last_esec 2@ Esec 2!
     then
     _tz.set cd.localtime
   ;
   : run
     init
     starttasker
   ;
   : run-turnkey
     applturnkey
     init
     starttasker
   ;
   \ ' run-turnkey to turnkey

   : .d ( -- )
     decimal
     .uptime         space space
     clock.show      space
     tick            @ . space
     ct.ticks.follow @ . space space
     .Esec                space
     Esec 2@  EsecOffset  2@ d+
     s>dt.short      clock.dot
     cr
   ;
