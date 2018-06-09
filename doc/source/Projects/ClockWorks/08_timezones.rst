.. _clockworks_timezones:

Timezones
=========

:Date: 2017-08-25

.. contents::
   :local:
   :depth: 1


Intro
-----

Timezones are a much needed feature around planet Earth to have noon
(highest elevation of the sun) near 12 o'clock local time. This little
feature alone is a surprisingly rich source of politics, skewed
geographical timescapes, and other oddities. Programmers, astronomers
and travellers may come across funny timezones with offsets not being
full hours. The concept of *daylight savings time* is like moving one
zone east during summer and coming back west during winter. Anyway, if
programming a clock, you might want to display *local time*, no matter
how odd its definition.

I decided to use Unix Epoch seconds as a second software clock on the
controller, and use it to create local time. The definition of any
timezone is reduced to a signed offset ranging from -43200 to 43200
(12*3600) at most. This value can be represented as a 32bit (2 cells)
signed variable.

I also decided to ignore the concept of daylight savings time. If you
need that concept, then define 2 timezones, and switch the timezone
appropriately --- not the clock itself.


..


This code is small and specific to a given hardware and use case. So
imho it belongs into the main program text and not into a separate
file.

Design Decisions
----------------

 * A timezone is represented by an offset in seconds applied to UTC,
   and a string label to identify it.

 * The offset fits into a 32bit memory location as a 32 bit signed
   variable.

 * There is no concept of daylight savings time.

Code Details
------------


MasterClock drives Epoch Seconds, too
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When setting the software master clock on startup, the corresponding
Unix Epoch Seconds are calculated and stored in ``2variable ESec``

.. code-block:: forth

   2variable Esec
   : ++Esec  ( -- )  Esec 2@  1. d+  Esec 2! ;
   : .Esec   ( -- )  Esec 2@ ud. ;

   : init
     ...
     +sw
     0. Esec    2!

     +i2c
     i2c_addr_rtc i2c.ping? if             \ if RTC available
       hwclock>clock                       \     read it, set clock
       clock.get ut>s.short Esec 2!        \     set epoch seconds
     else
       #1970 1 1 0 0 0 clock.set
       0. Esec 2!
     then
   ;

The counter ``Esec`` is incremented in ``job.sec`` and should follow
the counters of the MasterClock.

.. code-block:: forth

   : job.sec ...
     ++Esec
   ;



Pins to select timezone
^^^^^^^^^^^^^^^^^^^^^^^

On my clock the timezone is selected by reading 2 pins. Depending on
their values ``EsecOffset`` is set accordingly. The two timezones are
defined such that switching to daylight savings time is a matter of
selecting one of the two. I use a coding bridge or a switch for that.
Any other time zone definitions and more pins to select them would be
placed in this code fragment.

.. code-block:: forth

   PORTA $03 bitmask: _tz

   : +sw ( -- )          _tz pin_input ;

   2variable EsecOffset
   : UTC  ( -- )      0. EsecOffset 2! ;
   : MEZ  ( -- )  #3600. EsecOffset 2! ;
   : MESZ ( -- )  #7200. EsecOffset 2! ;


   : _tz.set
     _tz pin@
     dup 0 = if
       UTC
       led_utc on  led_mez off led_mesz off
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


In order to display *local* time read the value of ``ESec``, apply the
offset of the selected time zone and convert the result into the usual
hour, minute etc. counters. The result is sent to the display.

.. code-block:: forth

   : local.dt ( -- S M H d m Y )
     Esec 2@  EsecOffset 2@  d+  s>dt.short
   ;
   : cd.localtime
     local.dt                              \ -- S M H d m Y
     drop drop drop                        \ -- S M H
     rot drop swap                         \ -- H M
     >r #10 /mod swap                      \ -- H.10 H.1
     r> #10 /mod swap                      \ -- H.10 H.1 M.10 M.1
     #4 type.7seg                          \ --
   ;


This function displays hours and minutes, it is specific to the
available display (number and write order of digits), of course. The
function shall be called perodically.

.. code-block:: forth

   : job.min
     _tz.set cd.localtime
   ;

If you switch the time zone by adjusting the selection bridge, the new
time is displayed at the next call of ``cd.localtime``, i.e. at the
next minute in this case.

