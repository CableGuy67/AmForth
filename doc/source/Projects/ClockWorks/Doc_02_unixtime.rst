.. _epoch_seconds:

Date/Time to unix time and back
===============================

:Author: Erich Wälde
:Contact: amforth-devel@lists.sourceforge.net
:Date: 2015-11-11

To solve a particular problem with clocks, I decided to use epoch seconds
(aka unix time). So this recipe demonstrates a working implementation. For
starters we ask ``date`` for a current time stamp in epoch seconds:

.. code-block:: bash

   $ date +%s
   1446650000

The conversion back can be done, too:

.. code-block:: bash
 
   $ date -u -d @1445566000
   Fri Oct 23 02:06:40 UTC 2015

So we can produce test cases and verify or work.


leapyear?
---------

Along the way we need to decide, whether a given year is a leap year or
not. The current rule says: If the year is a multiple of 400, it is.
Otherwise If it is a multiple of 100, it is not. Otherwise if it is a
multiple of 4, it is a leap year, otherwise it's not. The code for this
function takes the top of stack element, applies the rules and returns a
true/false flag to the stack:

.. code-block:: forth

   : leapyear? ( yyyy -- t/f )
     dup    &4 mod 0=
     over &100 mod 0<> and
     swap &400 mod 0=  or
   ;

A small amount of testing has never done any harm, so we load the
corresponding module `lib/forth2012/tester/tester-amforth.frt`
and feed a hand full of tests to the controller after that.

.. code-block:: bash

   decimal
   t{ 1970 leapyear? ->  0 }t
   t{ 1972 leapyear? -> -1 }t
   t{ 1999 leapyear? ->  0 }t
   t{ 2000 leapyear? -> -1 }t
   t{ 2001 leapyear? ->  0 }t
   t{ 2004 leapyear? -> -1 }t
   t{ 1900 leapyear? ->  0 }t
   t{ 3900 leapyear? ->  0 }t
   t{ 3996 leapyear? -> -1 }t
   t{ 4000 leapyear? -> -1 }t

Running this code should list all tests as passed. This increases my
confidence into the code --- I can highly recommend test cases!


Manual conversion from epoch seconds to UT
------------------------------------------

We shall try to convert the value from the first example above back into
common date/time format. ``1445566000`` is greater than :math:`65536 == 2^{16}`

So with AmForth we need to use variables 2 cells wide. The function
``ud/mod`` (division with remainder) will help us with the calculation.

.. code-block:: bash

   decimal
   1445566000. 60 ud/mod .s 
   3  367 41054 40  ok

``40`` is the correct value for *seconds* (remainder), the large double length
number is the original number divided by 60, thus the time in full minutes.

.. code-block:: bash

   60 ud/mod .s 
   4  6 8330 6 40  ok

``6`` is the correct value for *minutes*, the large number is the time in full
hours. Division by 24 will lead us on:

.. code-block:: bash

   24 ud/mod .s 
   5  0 16731 2 6 40  ok

In other words, the initial value ``1445566000``
in epoch seconds represents ``02:06:40 UT`` time at
``16731`` days of the epoch, that is after ``1970-01-01``

So we need to convert the number of days into the correct number of years
and months, including handling of leap years. It would be nice to have
functions similar to ``ud/mod`` however, we need to come up with them ourselves.

It should be noted that we need to extract the correct number of years
first by subtracting days, and then convert the remaining days into months
and days.


How many full years are in N days?
----------------------------------

First we define a constant to hold the begin of the epoch. And after that a
funny named function, which returns the length of a given year in days.
These are just to make the remaining code more readable.

.. code-block:: forth

   #1970 constant __Epoch
   : 365+1 ( year -- 365|366 )
      #365 swap leapyear? if 1+ then
   ;

Then we define ``years/mod``
which extracts the full years from a given number of days. It returns the
corresponding year and the remainder of days. There is no magic in this
function, just a plain book keeping exercise. We need to correctly account
for leap years, the loop starts with the first year of the epoch, 1970.

.. code-block:: forth

   : years/mod ( T/day -- years T/day' )
      dup #365 u< 0= if         \ -- T
        __Epoch swap        \ -- year T
        begin
            over 365+1
            -
            swap 1+ swap    \ -- T-365 year+1
            over 365+1      \ -- year' T' 365
            over swap       \ -- year' T' T' 365
        u< until
      else
        __Epoch swap
      then
    ;

There might be more elegant solutions, however, this one works as the
following tests should demonstrate.

.. code-block:: forth

   t{     0 years/mod -> 1970   0 }t
   t{     1 years/mod -> 1970   1 }t
   t{    31 years/mod -> 1970  31 }t
   t{   364 years/mod -> 1970 364 }t
   t{   365 years/mod -> 1971   0 }t
   t{   366 years/mod -> 1971   1 }t
   t{   730 years/mod -> 1972   0 }t
   t{  1094 years/mod -> 1972 364 }t
   t{  1095 years/mod -> 1972 365 }t
   t{  1096 years/mod -> 1973   0 }t
   t{  1097 years/mod -> 1973   1 }t
   t{ 11322 years/mod -> 2000 365 }t
   t{ 11323 years/mod -> 2001   0 }t

Continuing the above conversion yields:

.. code-block:: bash

   > .s
   5  0 16731 2 6 40  ok
   d>s years/mod .s
   5  295 2015 2 6 40  ok
   > 

In the ``16731`` days are 45 full years, so the correct value for year is
``2015`` as expected. There are ``295`` days in that year left.


How many full months are in N days?
-----------------------------------

A similar exercise of book keeping leads us to extract the correct number
of months from the remainder above
: 295
.

So first I decided to create a list of accumulated days at the end of the
month. The list covers common years, leap years need to be accounted for
differently. Again, there is no particular magic. We search the list from
its far end down until the number from the list is smaller than the
remaining days given as argument.

.. code-block:: forth

   : months/mod ( year T/day -- year month T/day' )
     dup 0= if
        drop 1 1
     else
        &12 swap            \ -- year month T
        begin
            over __acc_days + @i       \ AmForth
     \  over cells __acc_days + @  \ gForth
                            \ -- year month T acc_days[month]
            \ correct acc_days for leap year and months > 1 (January)
            3 pick leapyear? 3 pick 1 > and if 1+ then
            over over swap  \ -- year month T acc_days[month] acc_days[month] T
            u>
        while               \ -- year month T acc_days[month]
            drop swap 1- swap
                            \ -- year month-1 T
        repeat              \ -- year month' T acc_days[month']
        -                   \ -- year month' T-acc_days[month']
        swap 1+
        swap 1+
      then
   ;

We test this with the ongoing conversion:

.. code-block:: bash

   > .s
   5  295 2015 2 6 40  ok
   > months/mod .s
   6  23 10 2015 2 6 40  ok
   > swap rot .s
   6  2015 10 23 2 6 40  ok
   >

The result is as expected. More tests can be applied:

.. code-block:: forth

   t{ 1970   0 months/mod -> 1970  1  1 }t
   t{ 1970   1 months/mod -> 1970  1  2 }t
   t{ 1970  30 months/mod -> 1970  1 31 }t
   t{ 1970  31 months/mod -> 1970  2  1 }t
   t{ 1970  59 months/mod -> 1970  3  1 }t
   t{ 1970  90 months/mod -> 1970  4  1 }t
   t{ 1970 120 months/mod -> 1970  5  1 }t
   t{ 1970 151 months/mod -> 1970  6  1 }t
   t{ 1970 181 months/mod -> 1970  7  1 }t
   t{ 1970 212 months/mod -> 1970  8  1 }t
   t{ 1970 243 months/mod -> 1970  9  1 }t
   t{ 1970 273 months/mod -> 1970 10  1 }t
   t{ 1970 304 months/mod -> 1970 11  1 }t
   t{ 1970 334 months/mod -> 1970 12  1 }t
   t{ 1970 364 months/mod -> 1970 12 31 }t
   t{ 1996   0 months/mod -> 1996  1  1 }t
   t{ 1996   1 months/mod -> 1996  1  2 }t
   t{ 1996  30 months/mod -> 1996  1 31 }t
   t{ 1996  31 months/mod -> 1996  2  1 }t
   t{ 1996  60 months/mod -> 1996  3  1 }t
   t{ 1996  91 months/mod -> 1996  4  1 }t
   t{ 1996 121 months/mod -> 1996  5  1 }t
   t{ 1996 152 months/mod -> 1996  6  1 }t
   t{ 1996 182 months/mod -> 1996  7  1 }t
   t{ 1996 213 months/mod -> 1996  8  1 }t
   t{ 1996 244 months/mod -> 1996  9  1 }t
   t{ 1996 274 months/mod -> 1996 10  1 }t
   t{ 1996 305 months/mod -> 1996 11  1 }t
   t{ 1996 335 months/mod -> 1996 12  1 }t
   t{ 1996 365 months/mod -> 1996 12 31 }t

This implementation may seem somewhat convoluted. I'm sure there are more
elegant solutions possible, however, readable code is highly valued, too.
Passing the tests increases our confidence.


Converting Epoch Seconds to UT
------------------------------

At this point we have the tools to convert unix time (epoch seconds) into
the well known and much better readable date/time format.

.. code-block:: forth

   : d>s   drop ;
   : s>ut  ( d:EpochSeconds -- sec min hour day month year/UT )
     #60 ud/mod          \ -- sec d:T/min
     #60 ud/mod          \ -- sec min d:T/hour
     #24 ud/mod          \ -- sec min hour d:T/day
     d>s
     years/mod           \ -- sec min hour year T/day
     months/mod          \ -- sec min hour year month day
     swap rot            \ -- sec min hour day month year
   ;

A fairly big list of test cases is nice. The last test will fail, because
it overflows the size of ``2variable``. The second to last test will succeed,
because I use unsigned values for unix time --- contrary to to the standard
definition. So this implementation is not impaired at the 2038 overflow and
keeps working until 2106.


.. code-block:: forth

   t{             0. s>ut ->  0  0  0  1  1 1970 }t
   t{          3600. s>ut ->  0  0  1  1  1 1970 }t
   t{         86400. s>ut -> 00 00 00 02 01 1970 }t
   t{      31536000. s>ut -> 00 00 00 01 01 1971 }t
   t{     100000000. s>ut -> 40 46 09 03 03 1973 }t
   t{     951782400. s>ut -> 00 00 00 29 02 2000 }t
   t{    1000000000. s>ut -> 40 46 01 09 09 2001 }t
   t{    1044057600. s>ut -> 00 00 00 01 02 2003 }t
   t{    1044144000. s>ut -> 00 00 00 02 02 2003 }t
   t{    1046476800. s>ut -> 00 00 00 01 03 2003 }t
   t{    1064966400. s>ut -> 00 00 00 01 10 2003 }t
   \ leap year, end of February
   t{    1077926399. s>ut -> 59 59 23 27 02 2004 }t
   t{    1077926400. s>ut -> 00 00 00 28 02 2004 }t
   t{    1077926410. s>ut -> 10 00 00 28 02 2004 }t
   t{    1078012799. s>ut -> 59 59 23 28 02 2004 }t
   t{    1078012800. s>ut -> 00 00 00 29 02 2004 }t
   t{    1078012820. s>ut -> 20 00 00 29 02 2004 }t
   t{    1078099199. s>ut -> 59 59 23 29 02 2004 }t
   t{    1078099200. s>ut -> 00 00 00 01 03 2004 }t
   t{    1078099230. s>ut -> 30 00 00 01 03 2004 }t
   t{    1078185599. s>ut -> 59 59 23 01 03 2004 }t
   t{    1096588800. s>ut -> 00 00 00 01 10 2004 }t
   t{    1413064016. s>ut -> 56 46 21 11 10 2014 }t
   t{    1413064100. s>ut -> 20 48 21 11 10 2014 }t
   \ 31 bit max
   t{    2147483648. s>ut -> 08 14 03 19 01 2038 }t
   t{    2147483649. s>ut -> 09 14 03 19 01 2038 }t
   \ 32 bit max
   t{    4294967295. s>ut -> 15 28 06 07 02 2106 }t
   \ this is still working because I use
   \ Epoch seconds as 32 bit *unsigned* integer
   \ in disagreement with the standard definition
   \ overflow here :-) with amForth, not gForth
   t{    4294967296. s>ut -> 16 28 06 07 02 2106 }t

The interested reade will note at this point, that time zones were not
considered up to this point.


Converting UT back to Epoch Seconds
-----------------------------------

The inverse function is another book keeping exercise. Beginning with the
year we convert the entries on the stack to days and then to increasingly
smaller units, adding up the appropriate values as needed. 


.. code-block:: forth

   : ut>s ( sec min hour day month year -- d:T/sec )
     \ add start value T=0
     0 over               \ -- sec min hour day month year T=0 year
     __Epoch              \ -- sec min hour day month year T year Epoch
     ?do
        i 365+1 +
     loop                 \ -- sec min hour day month year T/days
     2 pick 1-            \ -- sec min hour day month year T/days month-1
     __acc_days + @i      \ -- sec min hour day month year T/days acc_days[month] \ amForth
   \    cells __acc_days + @ \ -- sec min hour day month year T/days acc_days[month] \ gForth
     +                    \ -- sec min hour day month year T/days
     swap                 \ -- sec min hour day month T/days year
     leapyear? rot 2 > and if 1+ then
     \                    \ -- sec min hour day T/days
     swap 1- +            \ -- sec min hour T/days
     s>d
     #24 1 m*/ rot s>d d+  \ -- sec min T/hours
     #60 1 m*/ rot s>d d+  \ -- sec T/minutes
     #60 1 m*/ rot s>d d+  \ -- T/sec
   ;

More interesting test cases taken from Wikipedia:

.. code-block:: forth

   t{ 20 33 03  18 05 2033 ut>s 2000000000 }t
   t{ 00 40 02  14 07 2017 ut>s 1500000000 }t
   t{ 52 49 05  18 07 2029 ut>s  $70000000 }t
   t{ 36 25 08  14 01 2021 ut>s  $60000000 }t
   t{ 20 01 11  13 07 2012 ut>s  $50000000 }t
   t{ 40 46 09  03 03 1973 ut>s  100000000 }t

Time Zone CET/CEST
------------------

In order to handle time zones I decided to define constants providing the
offset to UT in seconds. This information is added to the stack before the
date and time values.

.. code-block:: forth

   #3600 constant CET
   #7200 constant CEST

   : dt>s ( tzoffset sec min hour day month year -- d:epochsec )
     ut>s
     rot s>d d-
   ;

And a last round of test cases:

.. code-block:: forth

   t{ CET   0  0  0  1  1 1970 dt>s ->      -3600. }t
   t{ CET   0  0  1  1  1 1970 dt>s ->          0. }t
   t{                       0. s>ut ->  0  0  0  1  1 1970 }t
   t{ CET  59 59 23  1  1 1970 dt>s ->      82799. }t
   t{ CET  59 59  0 02 01 1970 dt>s ->      86399. }t
   t{ CET   0  0  1  2  1 1970 dt>s ->      86400. }t
   t{                   86400. s>ut -> 00 00 00 02 01 1970 }t
   t{ CET   1  0  1  2  1 1970 dt>s ->      86401. }t
   t{ CET  59 59 23 31  1 1970 dt>s ->    2674799. }t
   t{ CET   0  0  0  1  2 1970 dt>s ->    2674800. }t
   t{ CET   1  0  0  1  2 1970 dt>s ->    2674801. }t
   t{ CET  59 59 23 28  2 1970 dt>s ->    5093999. }t
   t{ CET   0  0  0  1  3 1970 dt>s ->    5094000. }t
   t{ CEST 30 15 12  1  6 1971 dt>s ->   44619330. }t
   t{ CEST  6  3 17 12 10 2014 dt>s -> 1413126186. }t
   t{ CEST 00 00 00 29 06 2000 dt>s ->  962229600. }t
   t{ CET  00 00 00 29 01 2000 dt>s ->  949100400. }t
   t{ CET  00 00 00 28 02 2000 dt>s ->  951692400. }t
   t{               951692400. s>ut -> 00 00 23 27 02 2000 }t
   t{ CET  00 00 00 29 02 2000 dt>s ->  951778800. }t
   t{ CET   0  0  1  1  1 1970 dt>s ->          0. }t
   t{                       0. s>ut ->  0  0  0  1  1 1970 }t
   t{ CET   0  0  1 29  2 1972 dt>s ->   68169600. }t
   t{                68169600. s>ut ->  0  0  0 29  2 1972 }t
   t{ CET  00 00 01 28 02 1972 dt>s ->   68083200. }t
   t{                68083200. s>ut -> 00 00 00 28 02 1972 }t
   t{ CEST 40 46 03 09 09 2001 dt>s -> 1000000000. }t
   t{              1000000000. s>ut -> 40 46 01 09 09 2001 }t
   t{ CET  00 00 01 01 01 2004 dt>s -> 1072915200. }t
   t{              1072915200. s>ut -> 00 00 00 01 01 2004 }t

Happy Forthing.
