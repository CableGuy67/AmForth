.. _clockworks_main_abakus:

Model 2: The Abakus Clock
=========================

:Date: 2017-08-19

.. contents::
   :local:
   :depth: 1


Design Decisions
----------------

 * 32 ticks/sec, generated from main crystal (11.0592 MHz)
 * timeup clock with simple counters, no structures, no timezone
 * **optional:** uptime counter
 * **optional:** led.1 blinking 1/sec
 * multitasker
 * **new:** a battery backed real time clock is connected via i2c
 * **new:** start time is read from RTC
 * **new:** shift register drives LEDs as display


Description
------------

The code included below is a complete, working example, tested on an
atmega644p controller. The syntax for the includes is such that
``amforth-shell.py`` will upload the programm and resolve all
``#include file`` directives.

This clock is derived from the :doc:`Minimal Clock
<40_main_fairly_minimal>` by adding a geek display (:doc:`Abakus
Display <21_display_abakus>`) and a battery backed :doc:`RTC
<06_rtc_pcf8583>`.


.. figure:: i_abakus_display.jpg
   :width: 600 px



I2C RTC (PCF8583)
^^^^^^^^^^^^^^^^^

.. code-block:: forth

   #include i2c_rtc_pcf8583.fs

   

Abakus Display
^^^^^^^^^^^^^^

Obviously, we need to define the pin connected to the shift register,
and load the words to transfer data to the shift register(s)

.. code-block:: forth

   \ abakus display
   PORTD 2 portpin: sr_latch
   PORTD 3 portpin: sr_clock
   PORTD 4 portpin: sr_data

   #include shiftregister.fs



.. figure:: i_model2_1.jpg
   :width: 600 px

   **Controller Board** and display



.. figure:: i_model2_3.jpg
   :width: 600 px

   **Prototype Display** handrouted :-)
            
   
The Code
--------

.. code-block:: forth
   :linenos:
   :emphasize-lines: 7-9
                     
   \ 2017-08-16  main-02-abakus.fs
   \ Author: Erich Wälde
   \ License: this code is explizitly placed in the public domain
   \
   \ include syntax for upload with amforth-shell.py
   \
   \     11.059200 MHz main crystal
   \     timer/counter1
   \     32 ticks/second
   \
   \ minimal clock
   \ plus i2c, i2c RTC (pcf8583)
   \      display: shift registers (74x595) and LEDs
   \
   #include builds.frt
   #include erase.frt
   #include dot-base.frt
   #include imove.frt
   #include bitnames.frt
   #include marker.frt
   #include environment-q.frt
   #include dot-res.frt
   #include avr-values.frt
   #include is.frt
   #include dumper.frt
   #include interrupts.frt
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
   
   marker --start--
   
   \ --- ports, pins, masks
      
   PORTB 2 portpin: led.0
   PORTB 3 portpin: led.1  
   PORTB 4 portpin: led.2  
   PORTB 5 portpin: led.3
   
   PORTC 0 portpin: i2c_scl
   PORTC 1 portpin: i2c_sda
   
   \ abakus display
   PORTD 2 portpin: sr_latch
   PORTD 3 portpin: sr_clock
   PORTD 4 portpin: sr_data
   
   \ --- famous includes and other words
   : ms   ( n -- )       0 ?do pause 1ms loop ;
   : u0.r ( u n -- )     >r 0 <# r> 0 ?do # loop #> type ;
   : odd?  ( x -- t/f )  $0001 and 0= 0= ;
   : even? ( x -- t/f )  $0001 and 0= ;
   
   \ --- driver: status leds
   #include leds.fs
   
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
     0  \ prescaler
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
   $50 constant i2c_addr_rtc
   #include i2c_rtc_pcf8583.fs
   
   
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
   
   \ --- timer1 clock tick
   \ 32 ticks/sec
   \ timer_1_ overflow
   \ clock source main crystal/256
   #include clock_tick1_main.fs
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
     rtc.get    \ --
        year  !
     1- month !
     1- day   !
        hour  !
        min   !
        sec   !
     drop \ 1/100 secs
     year @   month @ 1+  tu.upd.limits
   ;
   : clock>hwclock ( -- )
     year @   month @ 1+  day @ 1+
     hour @   min   @     sec @
     tick @ #100 ticks/sec m*/
     ( Y m d H M S S/100 ) rtc.set
   ;
   
   #include shiftregister.fs
   #include abakus.fs
   : clock.display.abakus.time   ( -- )
     hour @  #10 /mod swap
     min  @  #10 /mod swap
     sec  @  #10 /mod swap
     6 type.abakus   
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
     clock.display.abakus.time
   ;
   : job.min
   ;
   : job.hour  ;
   : job.day   ;
   : job.month
     \ update length of month in tu.limits
     year @  month @ 1+  tu.upd.limits
   ;
   : job.year
                 \ update YYYY in eeprom of rtc
     \ year @  rtc.set.year
   ;
   
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
     +leds leds-intro
     #2017 1 1 0 0 0 clock.set  
     0. uptime 2!
     +ticks
     timeup.init
     +i2c
     i2c_addr_rtc i2c.ping? if
       hwclock>clock
     else
       #2017 1 1 0 0 0 clock.set  
     then
     +sr
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
     ct.ticks.follow @ .
     cr
   ;



