.. _clockworks_periodic_jobs:

Periodic Jobs
=============

:Date: 2017-08-09

.. contents::
   :local:
   :depth: 1

Intro
-----

With the previous sections we do have clock ticks, we do have the
tools to keep track of time, so now what? We need a means to update
the display *periodically* or do other fancy stuff, perhaps
*periodically* too? So this section will show one way to call
functions, every time a second, a minute, etc. is over.

Design Decisions
----------------

 * There will be a list of functions called *jobs*

 * There will be a section of code in the ``run-loop`` function, which
   inspects the overflow flags set in ``timeup`` and calls the above
   *jobs* and clears their flags

 * After each call of a *job* the main loop is run again to keep track
   of ticks and their duties. So this delays jobs for higher counters a
   little but not by much, but it calls ``job.ticks`` sooner again

Jobs
----

The *jobs* are regular functions which refrain from changing the
stack. They are defined, their XTs are stored in a flash table.

.. code-block:: forth

   : job.tick   ;
   : job.sec    ( count uptime? toggle LED? update display? ) ;
   : job.min    ( update display? ) ;
   : job.hour   ( hit the gong? ) ;
   : job.day    ;
   : job.month  year @  month @ 1+  tu.upd.limits ;
   : job.year   ;
   
   create Jobs
     ' job.tick ,
     ' job.sec , ' job.min ,   ' job.hour ,
     ' job.day , ' job.month , ' job.year ,

In order to call them in a loop, an index variable ``jobCount`` is
used. It is advanced from ``1`` (job.sec) to ``6`` every round through
the main loop.


.. code-block:: forth

   variable jobCount   
   : jobCount++ ( -- )  jobCount @  #6 < if  1 jobCount +!  then ;
                
**TODO:** give the magic ``#6`` a name?
   
Measuring Uptime
----------------

A simple application of the whole idea is to count the uptime. A
``2variable`` (32 bit) is defined. It is cleared at startup and
incremented every second.

.. code-block:: forth

   2variable uptime
   : .uptime   ( -- )  uptime 2@  decimal ud. [char] s emit   ;
   : ++uptime  ( -- )  1.  uptime 2@  d+  uptime 2! ;

   : init
     ...
     0. uptime  2!
   ;

   : job.sec   ( -- )   ++uptime ;

The uptime can be displayed with ``.uptime``, however, either after
exiting the main loop, or in the same or another job, or on the serial
prompt after adding the multitasker.

After some time a more elaborate version ``.uptime.dhms`` looks
better (``# u0.r`` is used, because ``.`` places a space after the
last digit):

.. code-block:: forth

   : .uptime.dhms  ( -- )
     uptime 2@
     #60 ud/mod  #60 ud/mod  #24 ud/mod
     drop
     #3 u0.r [char] d emit space
     #2 u0.r [char] : emit
     #2 u0.r [char] : emit
     #2 u0.r
   ;



Putting it all together
-----------------------

All jobs and their handling is defined in the main program file.
Checking the flags and calling the jobs needs to be done in
``run-loop``.

.. code-block:: forth

   \ main-....fs
   include ewlib/clockticks_clock_crystal.fs
   include ewlib/timeup_v1.fs
   include ewlib/leap_year_q.fs

   \ --- uptime
   2variable uptime
   : .uptime   ( -- )  uptime 2@  decimal ud. [char] s emit   ;
   : ++uptime  ( -- )  1.  uptime 2@  d+  uptime 2! ;
   
   \ --- timeup jobs ---------------------------
   : job.tick  ;
   : job.sec
     ++uptime
   ;
   : job.min
     \ update display?
   ;
   : job.hour
     \ hit the gong?
   ;
   : job.day   ;
   : job.month
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
     #6 < if
       1 jobCount +!
     then
   ;
   
   variable ticks
   : init
     ...
     0  ticks    !
     #6 jobCount !
     0. uptime  2!
     timeup.init
     +ticks
   ;

   : sec.over? ( -- t/f)  ticks @ 1+  ticks/sec > ;
   
   : run-loop
     init
     begin
       tick.over? if
         tick.over!                     \ acknowledge
         1 ticks +!                     \ increment ticks
         job.tick                       \ do something
       then

       sec.over? if
         ticks @ ticks/sec - ticks !    \ reduce ticks
         timeup                         \ advance clock counters
         1 jobCount !                   \ start jobs
       then

       
       jobCount @ bv tu.flags fset? if  \ run one job per loop
         jobCount @
         dup Jobs + @i execute
         bv tu.flags fclr
       then
       jobCount++

     again
   ;


This code is and looks very old, to my eyes it could use a little
refresh, /me thinks. On the other hand, it works ``:-)``




The Code
--------


.. code-block:: forth
   :linenos:


   \ 2015-10-11 ewlib/timeup_v0.0.fs
   \
   \ Written in 2015 by Erich Wälde <erich.waelde@forth-ev.de>
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
   \ variables
   \     tu.counts -- fields available as:
   \     tick sec min hour day month year
   \ words:
   \     timeup.init
   \     timeup
   \     lastday_of_month ( year month -- last_day )
   \     tu.get  ( -- S M H d m Y )
   \     tu.set  ( Y m d H M S -- )
   \     tu.show ( -- )
   
   #include leap_year_q.fs
       
   variable tu.flags
   
   variable tu.counts     #7 cells allot
   tu.counts            constant tick
   tu.counts #1 cells + constant sec
   tu.counts #2 cells + constant min
   tu.counts #3 cells + constant hour
   tu.counts #4 cells + constant day
   tu.counts #5 cells + constant month
   tu.counts #6 cells + constant year
   
   variable tu.limits     #6       allot
   
   create tu.lastday_of_month
      #31 , #28 , #31 , #30 , #31 , #30 ,
      #31 , #31 , #30 , #31 , #30 , #31 ,
   
   : lastday_of_month ( year month -- last_day )
     dup 1-                \ array starts at 0
     tu.lastday_of_month + @i
     swap #2 = if          \ if month == 2
       swap leap_year? if  \   if leap_year
         1+                \     month += 1
       then
     else                  \ else
       swap drop           \   remove year
     then
   ;
   
   : timeup.init
     0      tu.flags !
     tu.counts #8 erase
     #60    tu.limits 1 + c!
     #60    tu.limits 2 + c!
     #24    tu.limits 3 + c!
     #31    tu.limits 4 + c! \ fixme: may be wrong later!
     #12    tu.limits 5 + c!
   ;
   
   : timeup ( -- )
     $02 tu.flags fset                     \ secflag++
     1 sec +!                              \ sec++
     
     \ for ( sec ) min hour day month year
     #6 1 do
       i cells tu.counts + @   1+          \ Counts[i]+1
       i       tu.limits + c@              \ Limits[i]
       > if                                \ if C[i]+1 > L[i]
         0  i cells tu.counts +  !         \ . C[i]=0
         i 1+ bv tu.flags fset             \ . F[i+1]++
         1 i 1+ cells tu.counts + +!       \ . C[i+1]++
       then                                \ fi
     loop
   ;
   
   \ update lastday_of_month in tu.limits
   \ once current date is known
   : tu.upd.limits ( Y m -- )
     ( Y m ) lastday_of_month  tu.limits #4 + c!
   ;
