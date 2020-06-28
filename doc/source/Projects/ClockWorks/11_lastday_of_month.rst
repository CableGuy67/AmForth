.. _clockworks_lastday_of_month:

lastday_of_month
================

:Date: 2017-11-08

.. contents::
   :local:
   :depth: 1


Intro
-----

While writing this documentation I started to see that another code
block could move to a separate file: ``lastday_of_month``. This
function is not tied to the remaining code, so I decided to separate
it.


Details
-------

In the Gregorian Calendar used in the western world, months have
distinct lengths. The pattern for a common year is well known

.. code-block:: forth

   create gregorian_length_of_month
     #31 , #28 , #31 , #30 , #31 , #30 ,
     #31 , #31 , #30 , #31 , #30 , #31 ,
   
This list of numbers is stored in flash using the ``,`` (comma) word.
As a well known matter of fact, however, the length of February is
increased by one during leap years. So I wanted a function to produce
the correct result when needed.

.. code-block:: forth

   #include leap_year_q.fs

   : gregorian_lastday_of_month ( year month -- last_day )
     dup 1-                                \ array starts at 0
     gregorian_length_of_month + @i
     swap #2 = if                          \ if February
       swap leap_year? if                  \   if leap_year
         1+                                \     month += 1
       then                                \
     else                                  \ else
       swap drop                           \   remove year
     then                                  \
   ;


``lastday_of_month`` will consult the list defined above, and in case
its Februar and in case its a leap year, will increment the result by
one.

I decided to use the prefix ``gregorian_`` just in case.



The Code
--------

.. code-block:: forth
   :linenos:

   \ 2017-11-08 gregorian_lastday_of_month.fs
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
   \     gregorian_lastday_of_month ( year month -- last_day )

   #include leap_year_q.fs

   create gregorian_length_of_month
     #31 , #28 , #31 , #30 , #31 , #30 ,
     #31 , #31 , #30 , #31 , #30 , #31 ,

   : gregorian_lastday_of_month ( year month -- last_day )
     dup 1-                                \ array starts at 0
     gregorian_length_of_month + @i
     swap #2 = if                          \ if February
       swap leap_year? if                  \   if leap_year
         1+                                \     month += 1
       then                                \
     else                                  \ else
       swap drop                           \   remove year
     then                                  \
   ;



