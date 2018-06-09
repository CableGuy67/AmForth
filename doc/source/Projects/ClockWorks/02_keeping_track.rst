.. _clockworks_keeping_track:

Keeping Track of Time
=====================

:Date: 2017-08-08

.. contents::
   :local:
   :depth: 1

Intro
-----

While just counting clock cycles or seconds would still make a clock,
its usability would be seriously lacking. To be able to catch the next
train, we would like our clock to use the well known set of counters
used in the `Gregorian Calender
<https://en.wikipedia.org/wiki/Gregorian_calendar>`_ of the western
world. 

**seconds:** ranging from ``0`` to ``59`` (and very occasionally to
``60``)
    
**minutes:** ranging from ``0`` to ``59``

**hours:** ranging from ``0`` to ``23``, allthough a ``12 mod``
operation is applied to common clock faces and commonly used spoken
terms.

**days:** ranging from ``1`` to ``31`` during a month --- **offset by 1**

**months:** ranging from ``1`` to ``12`` --- **offset by 1**

**years:** being 2017 currently in the gregorian calender
    

However, if you think about this for a few moments, there is no
shortage of alternatives.

**seconds of a day:** ranging from ``0`` to ``86400-1``.

**minutes of a day:** ranging from ``0`` to ``1440-1``.

**epoch seconds used in the Unix world:** ranging from ``0`` on
1970-01-01 0h UTC to some fairly large number in the forseeable
future (like ``1502223440`` at the time of this writing)

**day of year:** ranging from ``1`` to ``365`` or ``366`` during the
course of a year, and possibly much further (`Julian Days
<https://en.wikipedia.org/wiki/Julian_day>`_ 
anyone?)

Other calendar systems use different values for the lengths of months
and years. I will not be concerned about them, but implementing
different time/calendar systems is not difficult.

There is no shortage of calendar systems, see this wikipedia article
for a `List of Calendars
<https://en.wikipedia.org/wiki/List_of_calendars>`_ .



    

Design Decisions
----------------

 * We shall implement the usual counters used in the `Gregorian
   Calender <https://en.wikipedia.org/wiki/Gregorian_calendar>`_ :
   seconds, minutes, hours, days, months, years

 * Hours range from ``0`` to ``23``, we shall ignore the concept of
   *am/pm flags*

 * Days and months shall start at ``0``, not ``1``

 * We shall certainly implement the concept of the `*leap year*
   <https://en.wikipedia.org/wiki/Leap_year>`_ 

 * We shall ignore the concepts of `*time zone*
   <https://en.wikipedia.org/wiki/Time_zone>`_ and `*daylight savings
   <https://en.wikipedia.org/wiki/Daylight_saving_time>`_ 
   time*. The clock will be running in some *local time zone*

 * We shall ignore the concept of the `*leap second*
   <https://en.wikipedia.org/wiki/Leap_second>`_ 

 * A function called ``timeup`` shall increment the lowest counter
   used (seconds) and then correctly keep track of all overflows (e.g.
   one hour or one day has passed). I have first found this concept in
   a book on PIC Microcontroller Programming (German: A.König/M.König
   --- Das PICmicro Profi-Buch, 1999, Franzis Verlag, ISBN
   3-7723-4284-1).

 * overflows will be recorded to enable a system of periodic jobs,
   allthough this is not strictly needed

 * the counters are defined as variables to keep it simple for now


Code Details
------------

This is going to be lengthy but not difficult, I hope.

Counters
^^^^^^^^

We need a set of the desired counters. I decided a very long time ago
to use an array, but also to add words to access certain fields directly.
Forth ``structures`` offer a cleaner way that I will show later on.

We have 7 counters: tick, sec, min, hour, day, month, year.
``variable`` allots 1 cell already, so we need another 6.

.. code-block:: forth

   variable tu.counts #6 cells allot
   
   
The values reside in an array starting at address ``tu.counts``. The
address of the seconds counter is at offset ``1 cells``, so I define a
constant to point there, and similar for the other counters.

.. code-block:: forth

   tu.counts            constant tick
   tu.counts #1 cells + constant sec
   tu.counts #2 cells + constant min
   tu.counts #3 cells + constant hour
   tu.counts #4 cells + constant day
   tu.counts #5 cells + constant month
   tu.counts #6 cells + constant year

With these definitions I can write

.. code-block:: forth
                
   sec @ .

without remembering, that sec is actually a field in an array. Also
when calling ``sec``, there is no index calculation done any more,
because I stored the result in a ``constant``.

Flags
^^^^^

I want to record any overflows that have occured. This information
fits into one bit, so I decided to use ``flags`` for them.

.. code-block:: forth

   include common/lib/flags.frt
   variable tu.flags
   
tu.flags offers space for 16 bit flags. They can be defined and used
*directly* like this

.. code-block:: forth

   1 bv tu.flags fset? if ... then

or by giving the bits explicit names

.. code-block:: forth

   tu.flags  1 flag: f.tu.sec.over

   f.tu.sec.over fset? if
     \ ... do something
     f.tu.sec.over fclr
   then


Limits
^^^^^^

We need a place to store the limits at which each of the counters is
overflowing. The values are smaller than ``255``, so I decided to use
an array of Bytes. ``year`` does not have such a limit, so 6 Bytes are
sufficient. Again, 2 Bytes get reserved by ``variable``.

.. code-block:: forth

   variable tu.limits  #4 allot

These values need to be initialized upon startup.

.. code-block:: forth

   : timeup.init
     0      tu.flags !                  \ clear flags
     tu.counts #8 erase                 \ clear counters
     #60    tu.limits 1 + c!            \ init limits
     #60    tu.limits 2 + c!
     #24    tu.limits 3 + c!
     #31    tu.limits 4 + c!            \ months: may be wrong!
     #12    tu.limits 5 + c!
   ;
                

Why don't I keep these limits in flash? Well, that would work for all
except the limit of ``month``. That limit varies between ``28`` and
``31`` and needs to be adjusted accordingly.


Leapyear?
^^^^^^^^^

Leap years are an integral part of the gregorian calender, so we better
have a function to determine, whether a given year is one or not. This
function is so simple that everyone rolls its own, maybe it should be
included in AmForth?

.. code-block:: forth

   \ ewlib/leap_year_q.fs
   \ is yyyy a leap year? answer yes (-1) or no (0)!
   : leap_year? ( yyyy -- t/f )
     dup    #4 mod 0=
     over #100 mod 0<> and
     swap #400 mod 0=  or
   ;


Last Day of Month
^^^^^^^^^^^^^^^^^

Unfortunately, the length of our months is not constant. And they do
not follow a simple scheme --- for political reasons very long ago. So
we have to make due with that somehow.

Firstly I create a table in flash. The index is ``month-1``, the value
is its length in days, good for a common year.

.. code-block:: forth

   create tu.lastday_of_month
      #31 , #28 , #31 , #30 , #31 , #30 ,
      #31 , #31 , #30 , #31 , #30 , #31 ,

Then I create a function to determine the last day of a given month in
a given year. This function consults the table just defined, but
checks whether February's result must be adjusted.

.. code-block:: forth

   : lastday_of_month ( year month -- last_day )
     dup 1-                             \ array starts at 0
     tu.lastday_of_month + @i
     swap #2 = if                       \ if month == 2
       swap leap_year? if               \   if leap_year
         1+                             \     month += 1
       then
     else                               \ else
       swap drop                        \   remove year
     then
   ;

Since we need to update the entry for month in the ``tu.limits`` table
regularly, I defined a function to do just that, too:

.. code-block:: forth

   : tu.upd.limits ( Y m -- )  lastday_of_month  tu.limits #4 + c! ;



Timeup: advance counters
^^^^^^^^^^^^^^^^^^^^^^^^

Now we should have all data structures and tools to increment one
counter and correctly infer, whether a higher counter needs to be
incremented as well.

``timeup`` is called, when a second has passed. So it sets the
corresponding flag and increments the ``sec`` counter.

.. code-block:: forth

   : timeup ( -- )
     $02 tu.flags fset                     \ secflag++
     1 sec +!                              \ sec++

     \ for ( sec ) min hour day month year
     #6 1 do
       i cells tu.counts + @   1+          \ Counts[i]+1
       i       tu.limits + c@              \ Limits[i]
       > if                                \ if Counts[i]+1 > Limits[i]
         0  i cells tu.counts +  !         \ . Counts[i]=0
         i 1+ bv tu.flags fset             \ . Flags[i+1]=1
         1 i 1+ cells tu.counts + +!       \ . Counts[i+1]++
       then                                \ fi
     loop
   ;
                
After that, it loops over these counters to see, whether the
corresponding limit has been reached. If this is the case, the
inspected counter (e.g. ``sec``) is reset to ``0``, the flag of the
next higher counter (``min`` in this case) is set (``i 1+ bv
tu.flags``) and the next higher counter is incremented. To make this
task possible as a loop, I decided to keep the counters of ``day`` and
``month`` with an offset of ``1``.



Get / Set / Show
^^^^^^^^^^^^^^^^

To set and inspect the counters, three more words are useful. Please
note that the counters ``day`` and ``month`` need offset-by-1
treatment, and that the setter also needs to update the entry of ``month``
in table ``tu.limits``.

.. code-block:: forth

   : tu.set ( Y m d H M S -- )
     sec ! min ! hour !
     1- day !
     over over
     1- month !
     year !
     ( Y m ) tu.upd.limits
   ;
   : tu.get ( -- S M H d m Y )
     sec @ min @ hour @
     day @ 1+ month @ 1+ year @
   ;
   : tu.show ( -- )
     tu.get
     #4 u0.r  #2 u0.r  #2 u0.r  [char] -  emit
     #2 u0.r  #2 u0.r  #2 u0.r
   ;



Putting it all together
-----------------------

These tools do show up in the main program in two places
 #. in ``init`` we need to call ``timeup.init``
 #. in ``run-loop`` we call ``timeup`` after determining that a second
    has passed

.. code-block:: forth

   \ main-04.fs
   include ewlib/clockticks_clock_crystal.fs
   include ewlib/timeup_v1.fs
   include ewlib/leap_year_q.fs

   variable ticks
   : init
     ...
     0 ticks !
     timeup.init
     +ticks
   ;

   : run-loop
     init
     begin
       tick.over? if
         tick.over!                     \ acknowledge
         \ ...                          \ one tick over, do someting
         1 ticks +!                     \ count ticks
       then

       ticks @ 1+  ticks/sec > if
         ticks @ ticks/sec - ticks !    \ reduce ticks
         timeup                         \ advance clock counters
         \ ...                          \ one second over, do something!
       then

     again
   ;
         
The recorded tu.flags are not yet used by the main program. This is
detailed in section :ref:`clockworks_periodic_jobs`.
                
The Code
--------

.. code-block:: forth
   :linenos:
                
   \ 2015-10-11 ewlib/timeup_v0.0.fs
   \
   \ Written in 2015--2017 by Erich Wälde <erich.waelde@forth-ev.de>
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
     $02 tu.flags fset                \ secflag++
     1 sec +!                         \ sec++
     
     \ for ( sec ) min hour day month year
     #6 1 do
       i cells tu.counts + @   1+     \ Counts[i]+1
       i       tu.limits + c@         \ Limits[i]
       > if                           \ if C[i]+1 > L[i]
         0  i cells tu.counts +  !    \ . C[i]=0
         i 1+ bv tu.flags fset        \ . F[i+1]++
         1 i 1+ cells tu.counts + +!  \ . C[i+1]++
       then                           \ fi
     loop
   ;
   
   \ update lastday_of_month in tu.limits
   \ once current date is known
   : tu.upd.limits ( Y m -- )
     ( Y m ) lastday_of_month  tu.limits #4 + c!
   ;




