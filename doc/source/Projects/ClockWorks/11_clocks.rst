.. _clockworks_clocks:

Software Clock Counters
=======================

:Date: 2017-11-08

.. contents::
   :local:
   :depth: 1


Intro
-----

It was kindly pointed out to me that what I did in the first version
(:doc:`Keeping Track of Time <02_keeping_track>`), namely 

 - creating an array:

   .. code-block:: forth
                      
       variable tu.counts #7 cells allot

 - giving individual names to the fields:

   .. code-block:: forth
                      
      ... constant tick
      ... constant sec
      ... constant min
      ...

 - adding some index magic to make it look like ordinary variables:

   .. code-block:: forth
                      
      tu.counts            constant tick
      tu.counts #1 cells + constant sec
      tu.counts #2 cells + constant min
      ...

is the predominant use case for ``structures``, provided in Forth in
general, and in AmForth, too. So a part of the code mentioned above
was changed and moved to a new file. While being at it, I added a
field ``__tz`` to hold a pointer to a string stored in flash. This
pointer can be used to print the label of a time zone. If only one set
of these variables is needed, the effort reduces to knowing an
interesting feature. If several sets are in use at the same time, this
might be useful.



Code Details
------------

Creating a ``clock`` amounts to ``allot``-ing an array of counters in
RAM. Each of these counters has a meaning like ``minute`` or ``hour``.
When dealing with one of several such clocks, we need to know the base
address of the array (distinct for each set of counters) and the
offsets into the array (distinct for each field, but identical across
each set of counters). The available defining words
``begin-structure`` and ``end-structure`` will help us:

.. code-block:: forth

   #include structures.frt
   
   begin-structure _clock_t
     field: __tick
     field: __sec
     field: __min
     field: __hour
     field: __day
     field: __month
     field: __year
     field: __tz
   end-structure


This provides the definition of the array and the meaning of its
fields. Normally one would create an instance of this structure and
use it by its name:

.. code-block:: forth

   #include buffer.frt

   _clock_t buffer: myclock


To read and display the value of a particular field we can write

.. code-block:: forth

   myclock __min @ .

So the phrase ``myclock __min`` actually places the address of this
field on the stack, just like an ordinary variable does. In particular,
``myclock`` places the base address of its associated array on the
stack, and ``__min`` adds the correct offset to it. Several instances
just use different names (``myclock_2``), but the code of ``__min``
remains unchanged.

When toying with the idea of using multiple such ``clock`` instances,
I did not want to explicitly prepend their name to every access of
their fields. But instead of using the name of the instance
(``myclock``), it does not matter how the base address is entered on
the stack before a call to ``__min``.

I decided to create variable (a user variable, see below) named
``_clock``, which will hold a valid base address at any time. So the
old definition of ``min``

.. code-block:: forth

   variable min    \ old code

now becomes

.. code-block:: forth

   : min   ( -- addr ) _clock @ __min   ;

This hides the complexity of dealing with possibly different
instances. ``min`` can be used like a variable, code like
``: .time ... min   @    #2 u0.r [char] : emit ... ;``
remains unchanged.

So in order to create an instance of such a ``clock``, including a
pointer to a label about its time zone name, a defining word is
needed: ``clock:``

.. code-block:: forth

   \ define a clock data array including
   \ a pointer to a string holding its name
   \ time zone, really.
   : clock: ( s" tz_label" <clock_name> -- )
     dp >r s, r>                   \ -- flash-p
     create 
     here dup   ( ram-p )   ,      \ -- flash-p ram-p
     over       ( flash-p ) ,
     _clock_t allot                \ -- flash-p ram-p
     _clock !
     tz !
   does>
     dup @i _clock !
     1+  @i     tz !
   ;

Please note that ``allot`` is called directly. ``buffer:`` is not
offering an advantage here, since there is a little more to do in the
runtime portion of this definition. The runtime part fetches the base
address of the associated array (in RAM) from flash and stores this
value in the variable ``_clock`` already mentioned. Additionally the
address of the time zone label is fetched and stored in the field
``__tz``. This may not be needed every time, but avoids keeping track
of a valid state.

Creating a clock instance then reduces to one line:

   
.. code-block:: forth

   s" UTC" clock:  MasterClock



There is one more thing to deal with. If the multitasker is running,
and if more than one task are accessing different clocks defined in
this way, they actually share a global variable ``_clock`` unless we
define it to be task-local:

.. code-block:: forth

   #36 user _clock

The exact reason for ``#36`` is not obvious at all: The task control
block currently uses 36 Bytes (``SYSUSERSIZE``) to store all
neccessary information belonging to a task, such as the location of
its stacks, how much of them are used, which task follows this one,
the current numerical base and so forth. 36 currently is the next
unused location, and there are currently 10 Bytes (``APPUSERSIZE``)
reserved in the task control block for such use.

Unfortunately ``user`` is defined in several different ways in
different Forths and we just have to deal with it. See:

 * AmForth source: ``avr8/user.inc``
 * `Technical Guide: User Area <http://amforth.sourceforge.net/TG/Architecture.html#user-area>`_
 * `Cookbook: User Area <http://amforth.sourceforge.net/TG/recipes/User.html>`_
 * `(german) Vierte Dimension 2017-03: M.Trute: Erlebnisse in USER-Space <http://wiki.forth-ev.de/lib/exe/fetch.php/vd-archiv:4d2017-04.pdf>`_


To make life more convenient for the user of all this, three more
functions are defined: ``.date``, ``.time`` to display the date or
time on the serial connection, and ``.tz`` to print the label pointed
to by field ``__tz``.


The Code
--------

.. code-block:: forth
   :linenos:

   \ 2017-07-14 ewlib/clocks_v0.3.fs
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
   \ create an infrastructure to accomodate more than one
   \ set of counters for a clock.
   \
   \ this attempts to spend RAM space and trade it for
   \ simpler code. Try to avoid converting times ...
   \
   \ RAM array of counters (cells)
   \ optional: uptime or epochseconds (double)
   \ optional: EsecOffset (double)
   \ 0: tick (optional)!
   \ 1: second
   \ 2: minute
   \ 3: hour
   \ 4: day (offset by 1)
   \ 5: month (offset by 1)
   \ 6: year
   \ 7: pointer to TZ string (flash)
   
   \ include lib/forth2012/facility/structures.frt
   #include structures.frt
   \ include lib/forth2012/core/buffer.frt
   
   begin-structure _clock_t
     field: __tick
     field: __sec
     field: __min
     field: __hour
     field: __day
     field: __month
     field: __year
     field: __tz
   end-structure
   
   \ variable _clock
   #36 user _clock
   : tick  ( -- addr ) _clock @ __tick  ;
   : sec   ( -- addr ) _clock @ __sec   ;
   : min   ( -- addr ) _clock @ __min   ;
   : hour  ( -- addr ) _clock @ __hour  ;
   : day   ( -- addr ) _clock @ __day   ;
   : month ( -- addr ) _clock @ __month ;
   : year  ( -- addr ) _clock @ __year  ;
   : tz    ( -- addr ) _clock @ __tz    ; 
   
   
   : .date  ( -- )
     year  @    #4 u0.r  \ [char] - emit
     month @ 1+ #2 u0.r  \ [char] - emit
     day   @ 1+ #2 u0.r
   ;
   : .time  ( -- )
     hour  @    #2 u0.r [char] : emit
     min   @    #2 u0.r [char] : emit
     sec   @    #2 u0.r
   ;
   : .tz ( -- )
     tz    @    icount itype 
   ;
   
   
   \ define a clock data array including
   \ a printing label for its time_zone.
   : clock: ( s" tz_label" <clock_name> -- )
     dp >r s, r>                   \ -- flash-p
     create 
     here dup   ( ram-p )   ,      \ -- flash-p ram-p
     over       ( flash-p ) ,
     _clock_t allot                \ -- flash-p ram-p
     _clock !
     tz !
   does>
     dup @i _clock !
     1+  @i     tz !
   ;
   
   \ s" UTC" clock:  MasterClock



