.. _clockworks_epochseconds:

Unix Epoch Seconds, revisited
=============================

:Date: 2017-09-01

.. contents::
   :local:
   :depth: 1


Intro
-----

`Unix Epoch Seconds <https://en.wikipedia.org/wiki/Unix_time>`_ are a
commonly used time scale with computers. They start at 1970-01-01
00:00:00h UTC and increase eversince. At the time of this writing they
have surpassed 1503689470. I decided to use them on the clocks to
simplify handling of timezones. A time zone can then be implemented as
an offset in seconds. This may not be the most simple method, but once
working conversion routines are available, they can be used easily.

Unix Epoch Seconds have no concept of leap seconds, so this time scale
is a little distorted occasionally.

Unix Epoch Seconds have traditionally been implemented as *signed*
32bit integer values. So there will be an instant, where this counter
wraps to negative values --- this is the cause of the so called
`year-2038 problem <https://en.wikipedia.org/wiki/Year_2038_problem>`_
. My implementation uses an *unsigned* 32bit counter, so the problem
moves out to 2106. In Detail:

 ======= ============== =======================
 N       Epoch seconds  Date_Time
 ======= ============== =======================
 2^31-1  2147483647     2038-01-19_03:14:07 UTC
 2^32-1  4294967295     2106-02-07_06:28:15 UTC
 ======= ============== =======================


Unix Epoch Seconds make for geeky displays, either in decimal (the
value 1500000000 was reached not so long ago at 2017-07-14 02:40:00
UTC) or in binary: you can see the year 2038 rollover coming!


Design Decisions
----------------

 - the conversion routines are stupid, they count days accumulated
   over the full years since 1970, and add days, hours, minutes, and
   seconds along the way.
 - ``2variables`` are used to hold the results
 - using them *unsigned* (which is just a decision of the programmer)
   gets rid of the year-2038 problem. Whether my hardware will see the
   year-2106 problem seems rather less likely.

This code has been published before on this site ( :doc:`Date/Time to
unix time and back <Doc_02_unixtime>` ) including some test cases.

However, by its very nature a clock is indicating increasing instances
in time, so calculating the same time spans over and over again seems
like a bit of a waste. Thus I added some shortcuts.

  - the ``.short`` variants of ``ut>s`` and ``s>dt`` use a known
    starting point stored in ``_last_esec`` and ``_last_epoch``. This
    point can be changed at the beginning of a new year, for example.
    **NB** the functions will fail if the point to be converted is
    *before* ``_last_esec``.




Code Details
------------


 - ``s>dt.short  ( d:EpochSeconds -- sec min hour day month year )``
 - ``ut>s.short  ( sec min hour day month year -- d:EpochSeconds )``



Putting it all together
-----------------------

The 2variable ``EsecOffset`` holds the offset of the current time zone
in seconds. The offset is applied to the ``Esec`` counter and then
converted to HMS counters and displayed:

.. code-block:: forth

   variable   _last_epoch
   2variable  _last_esec
   #2017        Evalue   EE_last_epoch
   #1483228800. 2Evalue  EE_last_esec

   #include epochseconds.fs
   2variable Esec
   : ++Esec  ( -- )  Esec 2@  1. d+  Esec 2! ;
   : .Esec   ( -- )  Esec 2@ ud. ;

   ...

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
   : job.min  ...
     cd.localtime
   ;
   : init
     ...
     0. Esec    2!
     EE_last_epoch _last_epoch  !
     EE_last_esec  _last_esec  2!
     #3600. EsecOffset 2! \ UTC+1
     ...
   ;


References
----------

 - `Unix Time (aka Epoch Seconds) <https://en.wikipedia.org/wiki/Unix_time>`_
 - `The Year 2038 Problem <https://en.wikipedia.org/wiki/Year_2038_problem>`_
 - :doc:`Date/Time to unix time and back <Doc_02_unixtime>`


The Code
--------

.. code-block:: forth
   :linenos:


   \ 2014-10-13  ew
   \
   \ Written in 2014-2017 by Erich Wälde <erich.waelde@forth-ev.de>
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
   \ words
   \     leapyear?   FIXME: there is an implementation in ewlib/timeup.fs as well
   \     __Epoch     1970, constant
   \     s>dt        ( d:EpochSeconds -- sec min hour day month year )
   \     s>dt.short  ( d:EpochSeconds -- sec min hour day month year )
   \     ut>s        ( sec min hour day month year -- T/sec )
   \     ut>s.short  ( sec min hour day month year -- T/sec )
   \
   \ internal use only
   \     365+1 ( year -- 365|366 )
   \     years/mod
   \     years/mod.short
   \     __acc_days  -- accumulated days of year at 1st of each month (0..11)
   \     months/mod

   \ #include m-star-slash.frt
   \ #include leap_year_q.fs

   &1970 constant __Epoch
   : 365+1 ( year -- 365|366 )
       &365 swap leap_year? if 1+ then
   ;
   : years/mod.short ( T/day -- years T/day' )
       dup &365 u>= if         \ -- T
           _last_epoch @ swap  \ -- year T
           begin
               over 365+1
               -
               swap 1+ swap    \ -- T-365/6 year+1
               over 365+1      \ -- year' T' 365
               over swap       \ -- year' T' T' 365
           u>= 0= until
       else
           _last_epoch @ swap
       then

   ;
   : years/mod ( T/day -- years T/day' )
       dup &365 u>= if         \ -- T
           __Epoch swap        \ -- year T
           begin
               over 365+1
               -
               swap 1+ swap    \ -- T-365/6 year+1
               over 365+1      \ -- year' T' 365
               over swap       \ -- year' T' T' 365
           u>= 0= until
       else
           __Epoch swap
       then
   ;
   create __acc_days 0 , &31 ,  &59 ,  &90 , &120 , &151 , &181 ,
                        &212 , &243 , &273 , &304 , &334 , &365 ,
   : months/mod ( year T/day -- year month T/day' )
       dup 0= if
           drop 1 1
       else
           &12 swap            \ -- year month T
           begin
               over __acc_days + @i
                               \ -- year month T acc_days[month]
               \ correct acc_days for leap year and months > 1 (January)
               3 pick leap_year? 3 pick 1 > and if 1+ then
               over over swap   \ -- year month T acc_days[month] acc_days[month] T
               u>
           while               \ -- year month T
                   drop swap 1- swap
                               \ -- year month-1 T
           repeat              \ -- year month' T acc_days[month']
           -                   \ -- year month' T-acc_days[month']
           swap 1+
           swap 1+
       then
   ;

   : s>dt.short  ( d:EpochSeconds -- sec min hour day month year )
       _last_esec 2@ d-
       &60 ud/mod          \ -- sec T/min
       &60 ud/mod          \ -- sec min T/hour
       &24 ud/mod          \ -- sec min hour T/day
       d>s
       years/mod.short     \ -- sec min hour year T/day
       months/mod          \ -- sec min hour year month day
       swap                \ -- sec min hour year day month
       rot                 \ -- sec min hour day month year
   ;

   : s>dt  ( d:EpochSeconds -- sec min hour day month year )
       &60 ud/mod          \ -- sec T/min
       &60 ud/mod          \ -- sec min T/hour
       &24 ud/mod          \ -- sec min hour T/day
       d>s
       years/mod           \ -- sec min hour year T/day
       months/mod          \ -- sec min hour year month day
       swap                \ -- sec min hour year day month
       rot                 \ -- sec min hour day month year
   ;

   : ut>s.short ( sec min hour day month year -- T/sec )
       \ add start value T=0
       0 over              \ -- sec min hour day month year T=0 year
       _last_epoch @       \ -- sec min hour day month year T year Epoch
       ?do
           i 365+1 +
       loop                \ -- sec min hour day month year T/days
       2 pick 1-           \ -- sec min hour day month year T/days month-1
       __acc_days + @i     \ -- sec min hour day month year T/days acc_days[month]
       +                   \ -- sec min hour day month year T/days
       swap                \ -- sec min hour day month T/days year
       leap_year? rot 2 > and if 1+ then
       \                   \ -- sec min hour day T/days
       swap 1- +           \ -- sec min hour T/days
       s>d
       24 1 m*/ rot s>d d+ \ -- sec min T/hours
       60 1 m*/ rot s>d d+ \ -- sec T/minutes
       60 1 m*/ rot s>d d+ \ -- T/sec
       _last_esec 2@ d+    \ -- T/sec
   ;

   : ut>s ( sec min hour day month year -- T/sec )
       \ add start value T=0
       0 over              \ -- sec min hour day month year T=0 year
       __Epoch             \ -- sec min hour day month year T year Epoch
       ?do
           i 365+1 +
       loop                \ -- sec min hour day month year T/days
       2 pick 1-           \ -- sec min hour day month year T/days month-1
       __acc_days + @i     \ -- sec min hour day month year T/days acc_days[month]
       +                   \ -- sec min hour day month year T/days
       swap                \ -- sec min hour day month T/days year
       leap_year? rot 2 > and if 1+ then
       \                   \ -- sec min hour day T/days
       swap 1- +           \ -- sec min hour T/days
       s>d
       24 1 m*/ rot s>d d+ \ -- sec min T/hours
       60 1 m*/ rot s>d d+ \ -- sec T/minutes
       60 1 m*/ rot s>d d+ \ -- T/sec
   ;
