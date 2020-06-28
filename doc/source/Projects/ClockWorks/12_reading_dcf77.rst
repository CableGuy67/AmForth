.. _clockworks_reading_dcf77:

==========================
 Reading the DCF77 Signal
==========================

:Date: 2017-10-01

.. contents::
   :local:
   :depth: 1


Intro
=====

Adding a DCF77 radio receiver to a clock is a fairly obvious feature,
in Europe at least. So here we go: the details of how the information
is transferred over the course of a minute is given e.g. on wikipedia
https://en.wikipedia.org/wiki/DCF77#Time_code_details Please note that
DCF77 is not the only time signal available. For a list consult
https://en.wikipedia.org/wiki/Radio_clock


The DCF77 signal is modulated by `amplitude shift keying`. Full power
of the carrier signal indicates one state, reduced power (ca. 15%)
indicates another state. Power is reduced at the beginning of each
second. A low state lasting 0.1 s indicates a bit value of ``0``. A
low state of 0.2 s indicates a bit value of ``1``. In second 59 no
power reduction occurs. It serves as a sync pattern to indicate the
start of the next minute at the beginning of the next falling edge.


The signal is generally ok to receive in large parts of Europe,
however, the signal might fade at any moment. Moreover the signal
might be disturbed in any way at any time, e.g. by lightning or
interference.

The DCF77 receiver chosen provides a TTL level signal, which is high
in idle, and goes low during the low power state of the carrier signal.

Design Decisions
================

 * The signal of the receiver is sampled during each tick of the
   MasterClock, 128 times per second. In my experience it is not a
   good idea to trigger interrupts at each edge of the receiver signal
   and try to measure the length of a pulse using a timer/counter
 * ``(dcf.tick)`` is doing the sampling and some book keeping. It is
   called via ``dcf.tick`` (a deferred word) which in turn is called
   in ``job.tick`` of the ``MasterClock``
 * The leading edge is detected if the last 16 readings lead to
   ``$000F``
 * pin readings of `high` are simply added up in counter ``dcfPulse``
   --- ``dcfPause`` remained unused for too long, so I removed it
 * the `end of a second` is at ``dcfTick == 127``. This is not
   neccessarily in sync with the ticks of the ``MasterClock``
 * At the end of a second these counters are evaluated. If
   ``dcfPulse`` is within ``9`` to ``12``, a valid bit ``0`` has been
   seen. If it is within ``20`` to ``25``, a valid bit ``1`` has been
   seen. If its value is below ``2``, a ``sync59`` has been seen, i.e.
   the last second before the start of the next minute. Every other
   value is regarded to be an error!
 * the extracted bit values are evaluated at the end of each second
   (they are not collected and evaluated together at the end of the
   minute)
 * a jump table with the current second as index is used to call
   functions, which evaluate the last bit value
 * all parity bits are evaluated. If any of them are not correct, the
   telegram is discarded
 * the concept of daylight saving time is implemented
 * the concept of leap seconds is ignored at this stage
 * if desired, the valid telegram is converted to Unix time, corrected
   to UTC and fed to the ``MasterClock`` at the end of the minute


This is quite a bit of material, but there is no shorter way, I'm afraid.


Structure
=========

 * sampling the radio signal (128/s) --- produces the Pulse Counter
 * evaluating Pulse (1/s) --- produces 1 Bit value
 * processing one bit (1/s) --- produces a data telegram and some
   flags (f.dcf.err ...)
 * processing one telegram (1/60s) --- produces a timestamp valid for
   the start of the next second. This can be copied over to
   MasterClock, if desired.


I shall attempt to explain the code starting from the fast part,
namely sampling the signal.


Code 0: Pin and LED
===================

The DCF77-receiver signal is connected to pin ``D[7]``. There also is
a LED definition, to show the signal or other state.


.. code-block:: forth

   PORTB 2 portpin: led.0
   : led_dcf  [: led.0 ;] execute ;

   \ dcf77 RX
   PORTD 7 portpin: _dcf


Reading the pin takes place in ``(dcf.tick)`` (see below) in a block
similar to this

.. code-block:: forth

   _dcf pin_low? if
       \ account low signal level (active)
   else
       \ account high signal level
   then


Code 1: dcf.tick --- sampling the radio signal
==============================================

``dcf.tick`` is a deferred word due to code organisation. At runtime
it always points to ``(dcf.tick)`` which is defined later in the
source code.

``(dcf.tick)`` is called through ``job.tick`` of the MasterClock, so
this routine runs ``ticks/sec`` (128) times per second. Its job is to
sample the signal over the course of a second so that at the end of
this second the received bit value is available.

So we declare a variable to count the (active) low samples.
Then we define a function to clear the counter, and another one to
increment it. These are for better readability only!

.. code-block:: forth

   variable dcfPulse                       \ sample count, reduced tx power
   : dcfPulse.clr  ( -- )  0 dcfPulse  ! ;
   : dcfPulse++    ( -- )  1 dcfPulse +! ;


In order to synchronize the dcf second to the radio signal, we add
some detection of the begining of the second (leading edge of signal).
Every sample is shifted into a 16-bit variable (``dcfEdge``).

.. code-block:: forth

   variable dcfTick                        \ separate tick for dcf
   : dcfTick++/mod ( -- )  dcfTick @ 1+ ticks/sec mod dcfTick ! ;
   variable dcfEdge                        \ edge detector
   #4                               constant dcfEdge:leading.bits
   1 dcfEdge:leading.bits lshift 1- constant dcfEdge:leading.mask
   : dcfEdge<<1    ( -- )  dcfEdge @ 1 lshift dcfEdge ! ;
   : dcfEdge+1     ( -- )  1 dcfEdge +! ;
   : dcfEdge?      ( -- )  dcfEdge @ dcfEdge:leading.mask = ;

   : dcfTick.set   ( -- )  dcfEdge:leading.bits dcfTick ! ;


If the resulting pattern is ``0x000f``, then I interpret this as a
leading edge, and ``dcfTick`` is set to ``4``. These magic numbers
have been moved into constants. I want to see the 4 low bits set, the
corresponding mask is constructed.

Setting ``dcfTick`` to ``4`` is a brutal thing, and it will be wrong
occasionally, e.g. in an electrically noisy environment. It might then
be needed to add some "window" in the time bookkeeping, where this
edge can be expected. It would be valid only during this window.


So we have all puzzle pieces now to write down the needed word.

.. code-block:: forth

   : (dcf.tick)
       dcfClock  1 tick +!         \ keep dcfClock ticking
       dcfTick++/mod               \ .
       dcfEdge<<1                  \ . edge detection

       _dcf pin_low? if
           \ active!
           dcfPulse++
           dcfEdge+1
           -1 dcf.led
       else
           0 dcf.led
       then

       dcfEdge? if                 \ keep dcfClock in sync with radio signal
           dcfTick.set             \ . this might be bad occasionally
       then

       \ dcfTick: 0 .. 127
       \ 127 indicates the last tick in this second
       dcfTick @ ticks/sec 1- = if
           dcf.sec                 \ handle "one second over"
       then
   ;

At the end of the current second we need to decide, what bitvalue was
received, and what to do with it. This work is hidden behind the call
to ``dcf.sec``.


Code 2: dcf.bit --- producing one bit value
===========================================

This function is called at the end of the current second to determine
the transmitted bit value. ``dcf.bit`` will look at ``dcfPulse`` (on
top of the stack) and return an appropriate result. The comparison
values in the nested ``if``-``else`` blocks depend on ``ticks/sec``.
They have been determined by staring at the debug output more than
anything else.

.. code-block:: forth

   -2 constant dcf.bit:sync59
   -1 constant dcf.bit:error
    0 constant dcf.bit:0
    1 constant dcf.bit:1
   : dcf.bit ( pulse -- bit|error )
     dup  #2 < if                dcf.bit:sync59 else
     dup  #9 < if f.dcf.err fset dcf.bit:error  else
     dup #13 < if                dcf.bit:0      else
     dup #20 < if f.dcf.err fset dcf.bit:error  else
     dup #26 < if                dcf.bit:1      else
                  f.dcf.err fset dcf.bit:error
     then then then then then
     swap drop
   ;

I think this function is pretty strict. Of all values ``0 .. 127``,
only a small portion is valid: ``0 .. 1`` is regarded as the sync in
second 59, ``9 .. 12`` is regarded as 0, ``20 .. 25`` is regarded
as 1, anything else triggers an error and thus an invalid
telegram. Nonetheless I have had only occasional difficulties to
receive a valid telegram.



Code 3: dcf.sec --- processing one bit value
============================================

``dcf.sec`` is a deferred word, again due to code organisation. At
runtime it always points to ``(dcf.sec)`` which is defined later in
the code. This function is called at the end of the current second.
The variable ``dcfPos`` holds the `position in the telegram`, i.e. the
current second in fact.

So in this code block we look at the value of ``dcfPulse``, consult
``dcf.bit`` to evaluate the received bit, and then call the
appropriate entry in the call table to process the bit just received.

``dcf.dbg.sec`` hides the details of debugging output, and we ignore
that for now.

.. code-block:: forth

   #include case.frt
   variable dcfPos

   : dcfPos++ ( -- ) dcfPos @ 1+ #60 mod dcfPos ! ;

   : (dcf.sec)
     dcfClock timeup
     0 tick !

     \ evaluate pulse/pause
     dcfPulse @ dcf.pulse>bit    dup dcfBit !
     ( bit ) case

       dcf.bit:0      of  0 dcfPos @ pos.cmd  dcf.dbg.sec  endof

       dcf.bit:1      of  1 dcfPos @ pos.cmd  dcf.dbg.sec  endof

       dcf.bit:error  of  f.dcf.err fset      dcf.dbg.sec  endof

       dcf.bit:sync59 of
         dcf.min
         dcf.tmp.counter.reset
         dcfErrCnt.set
       endof

     endcase
     dcfPulse.clr           \ reset pulse/pause
     dcfPos++
   ;



Code 4: calling into the jump table
===================================


In ``(dcf.sec)`` the real work is hidden in the calls into the jump table:

.. code-block:: forth

   ( bit value 0 or 1 )  dcfPos @  pos.cmd

``pos.cmd`` inspects the top of stack item and uses it as the index
into the jump table.

.. code-block:: forth

   : pos.cmd ( index -- )
     dup 0 #60 within if
       ( index ) pos_cmd_map +  @i execute
     else
       drop
     then
   ;


The function thus called will consume one more item of the stack,
namely the bit value.

So the `processing` is hidden in the functions listed in table
``pos_cmd_map``. All of these functions have the same structure


.. code-block:: forth

   :noname  ( 0|1 -- )
       if   ( bit:1  ) ...
       else ( bit:0  ) ...
       then ( always ) ...
   ;

So for every position in the telegram `something` needs to be done. As
an example we will look at the handling of Bits 21 to 28, i.e. the
minute value and its parity bit.


.. code-block:: forth

   \ #21 .. #28: Minute
   \ minute ones
   :noname if ( bit:1 )   #1 dcfTMin   +!  dcfPar++ then ;     #21 >rt
   :noname if ( bit:1 )   #2 dcfTMin   +!  dcfPar++ then ;     #22 >rt
   :noname if ( bit:1 )   #4 dcfTMin   +!  dcfPar++ then ;     #23 >rt
   :noname if ( bit:1 )   #8 dcfTMin   +!  dcfPar++ then ;     #24 >rt
   \ minute tens
   :noname if ( bit:1 )  #10 dcfTMin   +!  dcfPar++ then ;     #25 >rt
   :noname if ( bit:1 )  #20 dcfTMin   +!  dcfPar++ then ;     #26 >rt
   :noname if ( bit:1 )  #40 dcfTMin   +!  dcfPar++ then ;     #27 >rt
   \ minute parity bit
   :noname
     if   ( bit:1 )                         dcfPar++ then
     ( always )
     dcfPar? if f.dcf.parerr.min fclr  dcfErrCnt-- then
     0 dcfPar !
   ;                                                           #28 >rt


In Bits 21 to 27, if their value is 1, we add the corresponding
decimal value to ``dcfTMin``. Please note that this takes care of the
conversion from BCD to decimal as well. If the received bit value is
0, there is nothing to do, so there is no ``else`` clause. If the
received bit value is 1 we increment the parity variable ``dcfPar`` as
well.

.. code-block:: forth

   \ count 1 bits, really; result must be even
   : dcfPar++ ( -- )      1 dcfPar +! ;
   : dcfPar?  ( -- t/f )  dcfPar @ $01 and 0= ;

At the end, the least significant bit of ``dcfPar`` is consulted. If
it is 0, then all is well and we decrement ``dcfErrCnt``. This
variable counts the checks to be done while receiving a telegram and
must be 0 after the last bit of the telegram was processed.


Code 5: dcf.min --- processing a telegram
=========================================

``(dcf.min)`` again is called via deferred word ``dcf.min`` due to
code organisation. This function is called at the end of the current
minute. We check that we are indeed at the end of second ``#59``. If
so, we decrement ``dcfErrCnt`` one more time. Then we check that its
value has indeed dropped to zero --- this indicates that all checks to
the data telegram were successful. The result is saved in
``f.dcf.err`` for use elsewhere.

If all is well, and if ``f.dcf.commit`` is set, then we proceed to
convert the telegram and update the clocks ``dcfClock`` and
``MasterClock``, respectively. There is a potential problem here, if
updating these clocks takes a noticeable time, they end up a little
late.

The remainder of ``(dcf.min)`` is debug output and bookkeeping. There
is another potential problem with the debug output as well, it adds
possibly unexpected delays and the next call to ``(dcf.tick)`` might
be late.

.. code-block:: forth

   : (dcf.min) ( -- )
     dcfPos @ #59 =  if dcfErrCnt--    then
     dcfErrCnt @ 0=  if f.dcf.err fclr then
     \ this block runs at the *end* of second "59" i.e.
     \ at the start of second "00", thus copy counters
     f.dcf.err fclr? if
       f.dcf.commit fset? if
         dcfTemp>dcfClock
         dcfClock>MasterClock
         space [char] C emit \ FIXME: dbg conditional?
         f.dcf.insync fset \ dcfClock is in sync!
         f.dcf.commit fclr
       then
     then
     dcf.dbg.sec
     dcf.dbg.min
     f.dcf.commit fclr? if
       \ clear debug flags --- this is only to demonstrate resync/commit
       f.dcf.dbg fclr
     then
   ;



Updating the clocks from the DCF77 telegram is done in two steps. The
first function call (``dcfTemp>dcfClock``) copies the values collected
in the ``dcfT*`` counters into the clock counters of ``dcfClock``.
This clock runs independently from the master clock, ``tick`` and
``sec`` are just reset to zero. The clock is kept ticking from
``(dcf.sec)`` and it runs in the timezone indicated by DCF77.

.. code-block:: forth

   : dcfTemp>dcfClock
     dcfClock
     0                       tick  !
     0                       sec   !
     dcfTMin   @             min   !
     dcfTHour  @             hour  !
     dcfTDay   @  1-         day   !
   \ dcfTWday  @             ?
     dcfTMonth @  1-         month !
     dcfTYear  @  Century +  year  !
   ;




Updating ``MasterClock`` during the call to ``dcfClock>MasterClock``
is more work. As we have seen before, this is another deferred
function pointing to ``(dcfClock>MasterClock)``. We now have to take
care about the different time zones. ``dcfClock`` and ``MasterClock``
differ by one or two hours.

The new values are read from ``dcfClock``, converted to epoch seconds
(``ut>s.short``), corrected by one or two hours, converted back to
clock counter values (``s>dt.short``) and written into the counters of
``MasterClock``. Along the way ``Esec`` is updated, too.
Unfortunately, we once again have the potential problem, that these
steps might introduce more delay than acceptable.


.. code-block:: forth

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



I have to admit that writing documentation helps to see less than
ideal structure or implementation in my projects. So while I was aware
about the unwanted delays as pointed out above, this clock is still
useful for my daily life. I just would not expect more accuracy than a
couple of seconds, which may or may not be good enough for the problem
at hand.




Code 6: Some Debugging
======================


During development of the dcf part I needed a lot of debugging output.
Really a lot. But debugging output does have undesired consequences at
times. It can delay the processing of a tick --- visible clearly on
the traces of the logic analyzer.

``dcf.dbg.second.over`` emits one character per second to indicate the
state of the received bit. ``.`` and ``+`` indicate values of 0 and 1,
``/`` indicates an error, and ``S`` indicates the detection of the
sync event in second 59.


.. code-block:: forth

   : dcf.dbg.second.over ( -- )
     f.dcf.dbg.rx fset? if
       dcfBit @ case
         dcf.bit:0      of [char] . emit endof
         dcf.bit:1      of [char] + emit endof
         dcf.bit:error  of [char] / emit endof
         dcf.bit:sync59 of [char] S emit endof
       endcase
     then
   ;


``dcf.dbg.minute.over`` used to be quite large, but as indicated
above, it started to create problems --- which I still have not
understood in detail.

.. code-block:: forth

   \ short version
   : dcf.dbg.minute.over ( -- )
     space
     f.dcf.err fclr? if
       [char] O emit
     else
       [char] F emit
     then
     cr
   ;



Code 7: resyncing hourly
========================

I decided to request a new telegram to be committed to the running
clock once per hour. It will handle the appropriate flags and enable
debug output.

.. code-block:: forth

   : dcf.resync ( -- )
     f.dcf.insync fclr \ resync dcf time
     f.dcf.commit fset \ sync dcf -> MasterClock wanted
     f.dcf.dbg fset    \ dbg.min on
     f.dcf.dbg.rx fset \ dbg.sec on
   ;

   : job.min
     ...
     MasterClock min @  #58 = if dcf.resync then ;
   ;


The result can be seen on the console:

.. code-block:: console

   ~6F> .uptime.dhms
   859562s 9d 22:46:02 ok
   ~6F> .d
   859567 s  2017-12-11_19:55:56 UTC 24  24   1513022156  \
             2017-12-11_20:55:56 UTC 1513022156 1513022156 0
    ok
   ~6F> .+....++...+.++...+.++..++.+......+++...+.+...+..++++.+...+ CS O X
   .d
   860802 s  2017-12-11_20:16:32 UTC 92  93   1513023392  \
             2017-12-11_21:16:32 UTC 1513023392 1513023392 0
    ok
   ~6F>


Resyncing should be sufficient once per day, perhaps some time during
the night. Debug output is not needed any more, once the clock is in
production state. Note that the above output was edited manuallay ant
that the seconde "UTC" label above is wrong and should rather be "MEZ".


Putting it all together
=======================

Switching the whole wonderstuff on (and off) is all there is left to
do:

.. code-block:: forth

   : +dcf
     _dcf pin_input
     ['] (dcf.tick) to dcf.tick           \ register DCF77 functions
     ['] (dcf.sec)  to dcf.sec

     0 dcfPos !                           \ assume we are at position 0
     f.dcf.err fset                       \ error unless proven otherwise
     f.dcf.commit fset                    \ request to set dcfClock
     f.dcf.insync fclr                    \ not in sync yet!
     dcfErrCnt.set                        \ more errors unless proven otherwise
   ;

   : -dcf
     ['] noop to dcf.tick                 \ deregister DCF77 functions
     ['] noop to dcf.sec
   ;


This piece of code ist long. And I'm not even convinced it is nice and
good and clean code. It is one way to solve the problem, and I'm sure,
a few bugs or dragons are luring ...


Leftovers
=========

While this clock works, there is an uneasy feeling about it. There are
still things that could or should be improved. This is the list of
things I am aware of, there might be more, of course.

 * ``dcf.bit`` --- construct comparison values from ``ticks/sec``
   itself, since ``ticks/sec`` is defined at compile time, the
   comparison values might as well be calculated.

 * ``dcf.tick`` --- edge detection might be wrong under certain
   conditions; perhaps defining a `window` in time, where the edge is
   acceptable, could help. However, it is unclear at this point,
   whether this is a problem that occurs in practice.

 * ``dcf.min`` --- copying time counters from dcfClock to MasterClock
   takes some time, because timezones must be accounted for. So this
   intruduces a noticeable delay. The must be more clever ways to
   solve this. One thing could be to move some of the work to be done
   from the end of the current second to the middle of the second.
   There is plenty of idle time in this whole game.

 * ``dcf.min`` --- debug output over serial possibly introduces more
   delays thus delaying ``dcf.tick`` in possibly unacceptable ways.
   One could write the output to a larger ringbuffer and create a
   third task to output these charcters at more convenient times.
   However, adding debugging output makes the problem disappear or
   worse is a very common phenomenon in programming. So I'm sure there
   are better solutions available.





The Code
========

.. code-block:: forth
   :linenos:

   \ 2017-07-23  dcf_01.fs
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
   \ functions to sample dcf signal
   \     extract bit values,
   \     extract values from bits,
   \     verify parity
   \     provide debug output
   \
   \ needs
   \     #2000 constant Century
   \     PORTD 7 portpin: _dcf
   \     PORTB 2 portpin: led.0
   \     : led_dcf  [: led.0 ;] execute ;
   \
   \ words
   \     +dcf -dcf
   \     f.dcf.insync
   \     f.dcf.commit
   \     +DD +DRX

   variable dcfFlags
   dcfFlags   0 flag: f.dcf.err            \ any error, telegram invalid
   \  Flags   1 flag: f.dcf.???            \
   dcfFlags  #2 flag: f.dcf.commit         \ commit dcf -> masterclock wanted
   dcfFlags  #3 flag: f.dcf.dbg            \ debug output active
   dcfFlags  #4 flag: f.dcf.nosignal       \
   dcfFlags  #5 flag: f.dcf.insync         \ tell the world, dcf time is ok
   dcfFlags  #6 flag: f.dcf.CET            \ timezone bit
   dcfFlags  #7 flag: f.dcf.CEDT           \ daylight saving time bit
   dcfFlags  #8 flag: f.dcf.parerr.min     \ parity error minute
   dcfFlags  #9 flag: f.dcf.parerr.hour    \ parity error hour
   dcfFlags #10 flag: f.dcf.parerr.date    \ parity error date
   dcfFlags #11 flag: f.dcf.parerr         \ any parity error
   dcfFlags #12 flag: f.dcf.dbg.rx         \ debug output per received bit active
   \  Flags #13 flag: f.dcf.???
   \  Flags #14 flag: f.dcf.???
   \  Flags #15 flag: f.dcf.???

   variable dcfPulse                       \ sample count, reduced tx power
   : dcfPulse.clr  ( -- )  0 dcfPulse  ! ;
   : dcfPulse++    ( -- )  1 dcfPulse +! ;
   variable dcfBit                         \ value of last received bit
   variable dcfTick                        \ separate tick for dcf
   : dcfTick++/mod ( -- )  dcfTick @ 1+ ticks/sec mod dcfTick ! ;
   variable dcfEdge                        \ edge detector
   #4                               constant dcfEdge:leading.bits
   1 dcfEdge:leading.bits lshift 1- constant dcfEdge:leading.mask
   : dcfEdge<<1    ( -- )  dcfEdge @ 1 lshift dcfEdge ! ;
   : dcfEdge+1     ( -- )  1 dcfEdge +! ;
   : dcfEdge?      ( -- )  dcfEdge @ dcfEdge:leading.mask = ;

   : dcfTick.set   ( -- )  dcfEdge:leading.bits dcfTick ! ;

   variable dcfPos                         \ position in telegram, == dcf second
   : dcfPos++      ( -- )  dcfPos @ 1+ #60 mod dcfPos ! ;
   variable dcfPar                         \ collect parity
   : dcfPar++      ( -- )  1 dcfPar +! ;
   : dcfPar?       ( -- t/f )  dcfPar @ $01 and 0= ; \ even parity
   variable dcfErrCnt                      \ counter (down) of passed checks
   : dcfErrCnt--   ( -- )  -1 dcfErrCnt +! ;
   : dcfErrCnt.set ( -- )  #7 dcfErrCnt  ! ;

   \ these collect the bits in the DCF bit stream
   variable dcfTMin
   variable dcfTHour
   variable dcfTDay
   variable dcfTWday
   variable dcfTMonth
   variable dcfTYear

   : +DD  f.dcf.dbg fset ;
   : -DD  f.dcf.dbg fclr ;
   : .DD
     ." dcf.error:  " f.dcf.err     fset? if 1 else 0 then . cr
     ." dcf.parity: " f.dcf.parerr  fset? if 1 else 0 then . cr
     ." dcf.commit: " f.dcf.commit  fset? if 1 else 0 then . cr
     ." dcf.debug:  " f.dcf.dbg     fset? if 1 else 0 then . cr
     ." dcf.dbg.rx: " f.dcf.dbg.rx  fset? if 1 else 0 then . cr
   ;
   : +DRX  f.dcf.dbg.rx fset ;
   : -DRX  f.dcf.dbg.rx fclr ;


   \ create temporary RAM table
   variable dcf.tmp.table #60 cells allot \  only temporary really!
   \ fill RAM table with ' drop  \ noop -> drop: remove argument!
   ' drop dcf.tmp.table #60 ramtable.init
   \ dcf.tmp.table #60 ramtable.dump \ DEBUG
   : >rt ( xt idx -- )  dcf.tmp.table >ramtable ;

   \ code snippet XTs to ram table
   \ structure of functions
   \ :noname  ( 0|1 -- )
   \     if   ( bit:1  ) ...
   \     else ( bit:0  ) ...
   \     then ( always ) ...
   \ ;                                                      #idx >rt
   \ :noname
   \     drop ( always ) ...
   \ ;                                                      #idx >rt

   \ #0   always 0!
   :noname
     0= if ( bit:0 ) dcfErrCnt--
     then
   ;                                                           #0 >rt
   \ #1 .. #14  civil warning bits, MeteoTime data bits
   \ #15  call bit
   \ #16  1: day light savings time switch at the end of this hour
   \ #17  0 CET, 1 CEST
   :noname
     if   ( bit:1 ) f.dcf.CEDT fset
     else ( bit:0 ) f.dcf.CEDT fclr
     then
   ;                                                           #17 >rt
   \ #18  1 CET, 0 CEST
   :noname
     if   ( bit:1 ) f.dcf.CET fset   f.dcf.CEDT fclr? if dcfErrCnt-- then
     else ( bit:0 ) f.dcf.CET fclr   f.dcf.CEDT fset? if dcfErrCnt-- then
     then
   ;                                                           #18 >rt
   \ #19  1: leap second announcement
   \ #20  always 1: start of encoded time
   :noname
       if   ( bit:1 ) dcfErrCnt--
       then
       f.dcf.parerr      fset
       f.dcf.parerr.min  fset
       f.dcf.parerr.hour fset
       f.dcf.parerr.date fset
       0 dcfPar !
   ;                                                           #20 >rt
   \ #21 .. #28: minute
   \ minute ones
   :noname if ( bit:1 )   #1 dcfTMin   +!  dcfPar++ then ;     #21 >rt
   :noname if ( bit:1 )   #2 dcfTMin   +!  dcfPar++ then ;     #22 >rt
   :noname if ( bit:1 )   #4 dcfTMin   +!  dcfPar++ then ;     #23 >rt
   :noname if ( bit:1 )   #8 dcfTMin   +!  dcfPar++ then ;     #24 >rt
   \ minute tens
   :noname if ( bit:1 )  #10 dcfTMin   +!  dcfPar++ then ;     #25 >rt
   :noname if ( bit:1 )  #20 dcfTMin   +!  dcfPar++ then ;     #26 >rt
   :noname if ( bit:1 )  #40 dcfTMin   +!  dcfPar++ then ;     #27 >rt
   \ minute parity bit
   :noname
     if   ( bit:1 )                       dcfPar++ then
     ( always )
     dcfPar? if f.dcf.parerr.min fclr  dcfErrCnt-- then
     0 dcfPar !
   ;                                                           #28 >rt

   \ #29 .. #35: hour
   \ hour ones
   :noname if ( bit:1 )   #1 dcfTHour  +!  dcfPar++ then ;     #29 >rt
   :noname if ( bit:1 )   #2 dcfTHour  +!  dcfPar++ then ;     #30 >rt
   :noname if ( bit:1 )   #4 dcfTHour  +!  dcfPar++ then ;     #31 >rt
   :noname if ( bit:1 )   #8 dcfTHour  +!  dcfPar++ then ;     #32 >rt
   \ hour tens
   :noname if ( bit:1 )  #10 dcfTHour  +!  dcfPar++ then ;     #33 >rt
   :noname if ( bit:1 )  #20 dcfTHour  +!  dcfPar++ then ;     #34 >rt
   \ hour parity bit
   :noname
     if   ( bit:1 )                        dcfPar++  then
     ( always )
     dcfPar? if f.dcf.parerr.hour fclr  dcfErrCnt-- then
     0 dcfPar !
   ;                                                           #35 >rt
   \ #36 .. #41: day
   \ day ones
   :noname if ( bit:1 )   #1 dcfTDay   +!  dcfPar++ then ;     #36 >rt
   :noname if ( bit:1 )   #2 dcfTDay   +!  dcfPar++ then ;     #37 >rt
   :noname if ( bit:1 )   #4 dcfTDay   +!  dcfPar++ then ;     #38 >rt
   :noname if ( bit:1 )   #8 dcfTDay   +!  dcfPar++ then ;     #39 >rt
   \ day tens
   :noname if ( bit:1 )  #10 dcfTDay   +!  dcfPar++ then ;     #40 >rt
   :noname if ( bit:1 )  #20 dcfTDay   +!  dcfPar++ then ;     #41 >rt
   \ #42 .. #44: Wochentag
   \ day of week
   :noname if ( bit:1 )   #1 dcfTWday  +!  dcfPar++ then ;     #42 >rt
   :noname if ( bit:1 )   #2 dcfTWday  +!  dcfPar++ then ;     #43 >rt
   :noname if ( bit:1 )   #4 dcfTWday  +!  dcfPar++ then ;     #44 >rt
   \ #45 .. #49: Monat
   \ month ones
   :noname if ( bit:1 )   #1 dcfTMonth +!  dcfPar++ then ;     #45 >rt
   :noname if ( bit:1 )   #2 dcfTMonth +!  dcfPar++ then ;     #46 >rt
   :noname if ( bit:1 )   #4 dcfTMonth +!  dcfPar++ then ;     #47 >rt
   :noname if ( bit:1 )   #8 dcfTMonth +!  dcfPar++ then ;     #48 >rt
   \ month tens
   :noname if ( bit:1 )  #10 dcfTMonth +!  dcfPar++ then ;     #49 >rt
   \ #50 .. #57: Jahr % 100
   \ year ones
   :noname if ( bit:1 )   #1 dcfTYear  +!  dcfPar++ then ;     #50 >rt
   :noname if ( bit:1 )   #2 dcfTYear  +!  dcfPar++ then ;     #51 >rt
   :noname if ( bit:1 )   #4 dcfTYear  +!  dcfPar++ then ;     #52 >rt
   :noname if ( bit:1 )   #8 dcfTYear  +!  dcfPar++ then ;     #53 >rt
   \ year tens
   :noname if ( bit:1 )  #10 dcfTYear  +!  dcfPar++ then ;     #54 >rt
   :noname if ( bit:1 )  #20 dcfTYear  +!  dcfPar++ then ;     #55 >rt
   :noname if ( bit:1 )  #40 dcfTYear  +!  dcfPar++ then ;     #56 >rt
   :noname if ( bit:1 )  #80 dcfTYear  +!  dcfPar++ then ;     #57 >rt
   \ date parity bit
   :noname
     if   ( bit:1 )                        dcfPar++ then
     ( always )
     dcfPar? if f.dcf.parerr.date fclr  dcfErrCnt-- then
     f.dcf.parerr.min  fclr?
     f.dcf.parerr.hour fclr? and
     f.dcf.parerr.date fclr? and if f.dcf.parerr fclr then
   ;                                                           #58 >rt


   \ dcf.tmp.table #60 ramtable.dump \ DEBUG
   \ copy RAM table to FLASH
   dcf.tmp.table #60 >flashtable pos_cmd_map
   \ release RAM
   dcf.tmp.table to here \ fixme: possibly bad???

   : pos.cmd ( index -- )
     dup 0 #60 within if
       ( position ) pos_cmd_map +  @i execute
     else
       drop
     then
   ;

   -2 constant dcf.bit:sync59
   -1 constant dcf.bit:error
    0 constant dcf.bit:0
    1 constant dcf.bit:1
   : dcf.pulse>bit ( pulse -- bit|error )
     dup  #2 < if                dcf.bit:sync59 else
     dup  #9 < if f.dcf.err fset dcf.bit:error  else
     dup #13 < if                dcf.bit:0      else
     dup #20 < if f.dcf.err fset dcf.bit:error  else
     dup #26 < if                dcf.bit:1      else
                  f.dcf.err fset dcf.bit:error
     then then then then then
     swap drop
   ;

   : dcf.led ( t/f -- )
     if led_dcf on else led_dcf off then
   ;
   : dcf.dbg.minute.over ( -- )
     space
     f.dcf.err fclr? if
       [char] O emit
     else
       [char] F emit
     then
     cr
   ;
   : dcf.dbg.second.over ( -- )
     f.dcf.dbg.rx fset? if
       dcfBit @ case
         dcf.bit:0      of [char] . emit endof
         dcf.bit:1      of [char] + emit endof
         dcf.bit:error  of [char] / emit endof
         dcf.bit:sync59 of [char] S emit endof
       endcase
     then
   ;



   \ --- dcf.tick: 128/s, sample signal  ----
   Rdefer dcf.tick
   Rdefer dcf.sec
   Rdefer dcf.min

   : (dcf.tick)
       dcfClock  1 tick +!         \ keep dcfClock ticking
       dcfTick++/mod               \ .
       dcfEdge<<1                  \ . edge detection

       _dcf pin_low? if
           \ active!
           dcfPulse++
           dcfEdge+1
           -1 dcf.led
       else
           0 dcf.led
       then

       dcfEdge? if                 \ keep dcfClock in sync with radio signal
           dcfTick.set             \ . this might be bad occasionally
       then

       \ dcfTick: 0 .. 127
       \ 127 indicates the last tick in this second
       dcfTick @ ticks/sec 1- = if
           dcf.sec                 \ handle "one second over"
       then

       \ it is unclear whether deriving the dcf-second is
       \ ok from dcfTick, or whether ist must be
       \ dcfClock tick
       \ (dcf.tick) does both increments
       \ dcfTick is clear when calling dcf.sec
       \ dcf.sec clears dcfClock tick
   ;

   \ --- dcf.sec: 1/s, book keeping ---------
   : dcf.tmp.counter.reset
     #59 dcfPos  !
     0 dcfTMin   !
     0 dcfTHour  !
     0 dcfTDay   !
     0 dcfTWday  !
     0 dcfTMonth !
     0 dcfTYear  !
     0 dcfPar    !
   ;
   : dcfTemp>dcfClock
     dcfClock
     0                       tick  !
     0                       sec   !
     dcfTMin   @             min   !
     dcfTHour  @             hour  !
     dcfTDay   @  1-         day   !
   \ dcfTWday  @             ?
     dcfTMonth @  1-         month !
     dcfTYear  @  Century +  year  !
   ;

   : dcf.dbg.sec ( -- ) f.dcf.dbg fset? if dcf.dbg.second.over then ; \ debug
   : dcf.dbg.min ( -- ) f.dcf.dbg fset? if dcf.dbg.minute.over then ; \ debug

   : (dcf.sec)
     dcfClock timeup
     0 tick !

     \ evaluate pulse
     dcfPulse @ dcf.pulse>bit  dup dcfBit !
     ( bit ) case

       dcf.bit:0      of  0 dcfPos @ pos.cmd  dcf.dbg.sec  endof

       dcf.bit:1      of  1 dcfPos @ pos.cmd  dcf.dbg.sec  endof

       dcf.bit:error  of  f.dcf.err fset      dcf.dbg.sec  endof

       dcf.bit:sync59 of
         dcf.min
         dcf.tmp.counter.reset
         dcfErrCnt.set
       endof

     endcase
     dcfPulse.clr           \ reset pulse
     dcfPos++
   ;

   : (dcf.min) ( -- )
     dcfPos @ #59 =  if dcfErrCnt-- then
     dcfErrCnt @ 0=  if f.dcf.err fclr then
     \ this block runs at the *end* of second "59" i.e.
     \ at the start of second "00", thus copy counters
     f.dcf.err fclr? if
       f.dcf.commit fset? if
         dcfTemp>dcfClock
         dcfClock>MasterClock
         space [char] C emit
         f.dcf.insync fset \ dcfClock is in sync!
         f.dcf.commit fclr
       then
     then
     dcf.dbg.sec
     dcf.dbg.min
     f.dcf.commit fclr? if
       \ clear debug flags --- this is only to demonstrate resync/commit
       f.dcf.dbg fclr
     then
   ;

   \ --- init: enable DCF clock -------------
   : +dcf
     _dcf pin_input
     ['] (dcf.tick) to dcf.tick
     ['] (dcf.sec)  to dcf.sec
     ['] (dcf.min)  to dcf.min

     0 dcfPos !        \ assume we are at 0
     f.dcf.err fset    \ error unless proven otherwise
     f.dcf.commit fset \ request to set dcfClock
     f.dcf.insync fclr \ not in sync yet!
     dcfErrCnt.set
   ;
   : -dcf
     ['] noop to dcf.tick
     ['] noop to dcf.sec
   ;
