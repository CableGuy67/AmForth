.. _clockworks_main_utc_dcf77_wallclock:

Model 4: The Radio Controlled UTC Clock
=======================================

:Date: 2018-11-11

.. contents::
   :local:
   :depth: 1


Intro
-----

Design Decisions
----------------

 * 128 ticks/sec
 * uptime counter
 * multitasker
 * a battery backed real time clock is connected via i2c
 * start time is read from RTC
 * RTC generates 32768 Hz signal to drive clock ticks
 * run epoch seconds as additional software clock
 * use epoch seconds to derive times in 3 different time
   zones, read desired zone from 2 input pins
 * conversion to and from epoch seconds: additional
   ``.short`` versions use cached values for some epoch, e.g. 2017
 * shift register drives 7-segment digits as display
 * **new:** DCF77 receiver connected and sampled
 * **new:** additional software clock to track DCF77 time
 * **new:** sync: DCF77 time is written to ``masterclock`` during
   startup, after valid telegrams have been received
 * **new:** another sync is requested every hour.

Description
-----------

This clock uses the same hardware as
:doc:`Model 3 <42_main_utc_wall_clock>` except for one change: the external
DCF77 receiver signal is connected to Pin ``D.7``.

The code below is a complete, working example, tested on an atmega644p
controller. The syntax for the includes is such that
``amforth-shell.py`` will upload the programm and resolve all
``#include file`` directives.


Connecting to DCF77
-------------------

The additions to the main program are fairly straight forward. We need
to define the pin to which the receiver is connected. And while we are
at it, we also define an alias name for an led to indicate dcf77
activity.


.. code-block:: forth

   \ dcf77 RX
   : led_dcf  [: led.0 ;] execute ;
   PORTD 7 portpin: _dcf


We then need some more functions to control everything.

.. code-block:: forth

   \ --- DCF77 receiver
   Rdefer dcfClock>MasterClock
   
   s" DCF" clock: dcfClock
   #include ramtable_to_flash.fs
   #include dcf_01.fs
   
   : dcf.resync ( -- )
       \ request update of masterclock from dcf
   ;
   
   \ copy time from dcfClock to MasterClock
   : (dcfClock>MasterClock)
       \ update masterclock from dcfclock
       \ take care of time zones
   ;


*Running* ``dcfClock`` is hooked into ``job.tick``.

.. code-block:: forth

   : job.tick
     dcf.tick
   ;


*Updating* the counters of ``MasterClock`` needs some additional
handling at the start of a minute. Please note that ``dcf.min`` is
**not** hooked into ``job.min``, because the end of the minute may
differ between ``dcfClock`` and ``MasterClock``.

.. code-block:: forth

   : job.min
     f.mc.insync fclr? if
       f.dcf.insync fset? if
         \ dcfClock>MasterClock
         clock>hwclock
         -DD -DRX
         f.mc.insync fset
       then
     then
     _tz.set cd.localtime
     MasterClock min @  #58 = if dcf.resync then ;
   ;


And not surpisingly, all of this code needs to be activated at startup
of the system:


.. code-block:: forth

   : init
       \ ...
       ['] (dcfClock>MasterClock) to dcfClock>MasterClock
       +dcf
       \ f.dcf.dbg fset \ debug dcf
       \ f.dcf.dbg.rx fset
       f.dcf.commit fset
       led.3 on \ commit pending
       led.2 on \ dcf error unless proven otherwise
       +DD +DRX
   ;
    
                


The Code
--------

.. code-block:: forth
   :linenos:
   :emphasize-lines: 16-19

   \ 2017-09-24  main-30-utc-dcf-wallclock.fs
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
   \ plus
   \     stationID, redefined ready-prompt

   \ _include builds.frt
   #include erase.frt
   #include dot-base.frt
   \ _include imove.frt
   #include bitnames.frt
   #include marker.frt
   #include environment-q.frt
   #include dot-res.frt
   #include avr-values.frt
   #include is.frt
   \ _include dumper.frt
   \ _include interrupts.frt
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
   #include case.frt

   marker --start--

   $006f Evalue stationID

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
   \ dcf77 RX
   PORTD 7 portpin: _dcf

   \ --- famous includes and other words
   : ms   ( n -- )       0 ?do pause 1ms loop ;
   : u0.r ( u n -- )     >r 0 <# r> 0 ?do # loop #> type ;
   : odd?  ( x -- t/f )  $0001 and 0= 0= ;
   : even? ( x -- t/f )  $0001 and 0= ;

   : .stationID_ready
     cr
     [char] ~ emit
     base @  $10 base !  stationID 2 u0.r  base !
     [char] > emit space
   ;

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
   #include clocks_v0.3.fs
                                           \ newfangled clock:
                                           \ data as structure
                                           \ sec min hour day month year
                                           \ .date .time .tz
   s" UTC" clock: MasterClock
                                           \ create the "master" clock
   variable mcFlags
   mcFlags  0 flag: f.mc.insync

   \ --- timeup
   #include timeup_v1.0.fs
                                           \ last_day_of_month ( year month -- last_day )
                                           \ timeup.init
                                           \ timeup
                                           \ tu.upd.limits ( Y m -- )

   \ --- uptime
   2variable uptime
   : ++uptime ( -- )  1. uptime d+! ;
   : .uptime  ( -- )  uptime 2@  decimal ud. [char] s emit ;
   : du.i     ( d -- )  <# #s #> type ;
   : ud.dhms  ( d:T/sec -- )
     2dup decimal du.i [char] s emit space
     &60 ud/mod  &60 ud/mod  &24 ud/mod
     du.i   [char] d emit space    \ days
     2 u0.r [char] : emit          \ hours
     2 u0.r [char] : emit          \ minutes
     2 u0.r                        \ seconds
   ;
   : .uptime.dhms  uptime 2@ ud.dhms ;

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
     #2 u0.r [char] : emit #2 u0.r [char] : emit #2 u0.r  space .tz
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
   : ++Esec  ( -- )  1. Esec d+! ;
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
   \ --- DCF77 receiver
   Rdefer dcfClock>MasterClock

   s" DCF" clock: dcfClock
   #include ramtable_to_flash.fs
   #include dcf_01.fs

   : dcf.resync ( -- )
     f.dcf.insync fclr \ resync dcf time
     f.dcf.commit fset \ sync dcf -> MasterClock wanted
     f.dcf.dbg fset    \ dbg.min on
     f.dcf.dbg.rx fset \ dbg.sec on
   ;

   \ copy time from dcfClock to MasterClock
   : (dcfClock>MasterClock)
     dcfClock
     sec  @     min   @     hour @
     day  @ 1+  month @ 1+  year @
     MasterClock
                       \ -- sec min hour day month year
     \ convert "local time" to epoch seconds
     ut>s.short        \ -- T/sec
     \ adjust local time zone
     f.dcf.CEDT fset? if
       #3600. d-
     then
     #3600. d-
     2dup Esec 2! \ copy to Epoch seconds!

     \ convert back to "UTC date time" format
     s>dt.short        \ -- sec min hour day month year

     MasterClock
     year !  1- month !  1- day  !
     hour !  min      !  sec     !

     \ fixme: might cause wreaking havoc?
     dcfClock tick @
     dup MasterClock tick !
     ct.ticks.follow !
   ;

   \ --- multitasker
   #include multitask.frt
   : +tasks  multi ;
   : -tasks  single ;


   \ --- timeup jobs ---------------------------
   : job.tick
     dcf.tick
   ;
   : job.sec
     ++uptime
     ++Esec
   ;
   : job.min
     f.mc.insync fclr? if
       f.dcf.insync fset? if
         \ dcfClock>MasterClock
         clock>hwclock
         -DD -DRX
         f.mc.insync fset
       then
     then
     _tz.set cd.localtime
     MasterClock min @  #58 = if dcf.resync then ;
   ;
   : job.hour  ;
   : job.day   ;
   : job.month
     \ update length of month in tu.limits
     MasterClock
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
         MasterClock
         1 tick +!
         job.tick
       then

       half.second.over?
       dup 0<> if
         dup odd? if       \ half second
           led.1 off
         else              \ second
           led.1 on
           MasterClock
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
   $80 $80 $80 task: task-masterclock \ create task space
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
     ['] .stationID_ready is .ready

     0. uptime 2!
     0. Esec   2!
     EE_last_epoch _last_epoch  !
     EE_last_esec  _last_esec  2!

     MasterClock
     UTC
     #2017 1 1 0 0 0 clock.set
     timeup.init
     +ticks

     +i2c
     i2c_addr_rtc i2c.ping? if
       hwclock>clock
       clock.get ut>s.short Esec 2!
     else
       _last_epoch @ 1 1 0 0 0 clock.set
       _last_esec 2@ Esec 2!
     then
     _tz.set cd.localtime

     ['] (dcfClock>MasterClock) to dcfClock>MasterClock
     +dcf
     \ f.dcf.dbg fset \ debug dcf
     \ f.dcf.dbg.rx fset
     f.dcf.commit fset
     led.3 on \ commit pending
     led.2 on \ dcf error unless proven otherwise
     +DD +DRX
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

   : .dcf.diff
     \ 1 \ daylight saving time
     0 \ not daylight saving time
     dcfClock clock.get MasterClock
     dt>s 2dup ud.
     Esec 2@ 2dup ud.
     d- d.
   ;

   : .d ( -- )
     decimal
     .uptime         space space
     clock.show      space
     tick            @ . space
     ct.ticks.follow @ . space space
     .Esec                space
     Esec 2@  EsecOffset  2@ d+
     s>dt.short      clock.dot space
     f.dcf.commit fclr? if .dcf.diff then
     cr
   ;
