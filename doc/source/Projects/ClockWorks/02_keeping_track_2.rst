.. _clockworks_keeping_track_2:

Keeping Track of Time, revisited
================================

:Date: 2017-11-03

.. contents::
   :local:
   :depth: 1

Intro
-----

The original code in ``timeup_v0.0.fs`` was cleaned by moving two
blocks of code to their own files:

 - the handling of several software clocks using ``structures``. Moved
   to ``clocks_v0.3.fs``.
 - calculating the last day of a given month in the gregorian
   calendar, thereby correctly accounting for leap years. Moved to
   ``gregorian_last_day_of_month.fs``.


Details
-------

This is what remains in ``timeup_v1.0.fs``:

``timeup`` is the function, which is called after a second has passed
to increment the ``__sec`` field and any higher counters as needed.
The file holds this function and all the additional infrastructure
needed:

``tu.flags`` to hold the bit flags indicating various conditions

``tu.limits`` to hold the limits for each counter 

``timeup.init`` to create a valid state

``tu.upd.limits`` to update the limit of day (length of month)


In ``timeup`` itself, I decided to unfold the loop in this function
into a somewhat lengthy nested ``cond? if ... then`` block. The loop
was shorter in code but not simpler to read. I hope that this is
simpler to read when I come back to this code in the future.


.. code-block:: forth
   :linenos:

   \ 2017-11-08 timeup_v1.0.fs
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
   \ words:
   \     timeup.init
   \     timeup                    \ called in run-masterclock
   \     tu.upd.limits ( Y m -- )  \ called in job.month
   \ in main.fs
   \ s" UT" clock: MasterClock
   
   #include gregorian_lastday_of_month.fs
       
   variable tu.flags
   
   variable tu.limits  #6 allot
   : tu.max.sec   tu.limits  1+  ;
   : tu.max.min   tu.limits #2 + ;
   : tu.max.hour  tu.limits #3 + ;
   : tu.max.day   tu.limits #4 + ;
   : tu.max.month tu.limits #5 + ;

   : timeup.init
     0      tu.flags !
     #60  tu.max.sec   c!
     #60  tu.max.min   c!
     #24  tu.max.hour  c!
     #31  tu.max.day   c! \ must be corrected later!
     #12  tu.max.month c!
   ;

   \ update lastday_of_month in tu.limits
   \ once current date is known
   : tu.upd.limits ( Y m -- )
     ( Y m ) gregorian_lastday_of_month  tu.max.day  c!
   ;
                
   \ requires _clock to be set correctly!
   \ is called at "second over"
   \ original loop replaced by if-else chain,
   \ which is short-cutting as well
   : timeup ( -- )
     1 sec +!                         \ sec++
     $02 tu.flags fset                \ secflag++
   
     sec @ 1+  tu.max.sec c@ > if
       \ min.over
       tu.max.sec c@ negate  sec +!   \ sec -= max.sec
       1 min +!                       \ min++
       $04 tu.flags fset              \ minflag++
   
       min @ 1+  tu.max.min c@ > if
         \ hour.over
         0 min !
         1 hour +!
         $08 tu.flags fset
   
         hour @ 1+  tu.max.hour c@ > if
           \ day.over
           0 hour !
           1 day +!
           $10 tu.flags fset
           \ fixme: day of year++
           \ fixme: day of week++ % 7
   
           day @ 1+  tu.max.day c@ > if
             \ month.over
             0 day !
             1 month +!
             $20 tu.flags fset
   
             month @ 1+  tu.max.month c@ > if
               \ year.over
               0 month !
               1 year +!
               $40 tu.flags fset
               \ fixme: reset day of year
             then
           then
         then
       then
     then
   ;
   
