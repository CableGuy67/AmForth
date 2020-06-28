.. _clockworks:

=============
 Clock Works
=============
   
:Author:   Erich Wälde
:Contact:  amforth-devel@lists.sourceforge.net
:Date:     2018-12-15
:License:  CC BY-NC-SA


.. contents::
   :local:
   :depth: 1


Intro
=====

This is the top page of a project, which deals with clocks. However,
this project did happily explode into a large collection of fun
projects, too many to do them all. Instead of giving up, I decided to
do a series of documentation units, starting with the bare minimum and
adding optional units to cover other things.

If you speak or read German: a lot of this material has been covered
in the journal "Vierte Dimension" of "Forth Gesellschaft e.V."
available at https://www.forth-ev.de
and https://wiki.forth-ev.de/doku.php/vd-archiv
starting 2016-04 and references therein. There is a corresponding page
for some source code and pointers in the wiki as well, see
https://wiki.forth-ev.de/doku.php/projects:clockworks:clockworks

Warning
=======

Let's be very clear about this: **Noone needs yet another clock!** ---
there are way too many of them already dictating our course during the
day. But if you decide to ignore this warning and try to make your own
nonetheless, you will enter a whole new world of little wonders,
fantastic sights, and incredible creativity. Welcome to the world of
AmForth on atmega microcontrollers, time, and clocks. Have the
appropriate amount of fun!

License
=======

**AmForth** is licensed under GPLv3 (since version 5.6), and GPLv2
before. 

**This documentation** is licensed under `CC-BY-NC-SA (Creative
Commons Attribution-NonCommercial-ShareAlike 4.0 International
License) <http://creativecommons.org/licenses/by-nc-sa/4.0/>`_. This
documentation is not part of AmForth, allthough it is kindly hosted
here.

The **example code** (even when included in the documentation) is
placed under the `CC0 (Creative Commons Zero License, 1.0 unported)
<http://creativecommons.org/publicdomain/zero/1.0/>`_.
This should be equivalent to placing the example code directly in the
public domain, worldwide!


What can you do with the example code?

 #. You can take the example code, verbatim or modified, and run it on
    a device of your choice.

 #. You can use the example code to create your own project.
    

 #. You can give the example code verbatim or modified to your
    neighbour, or better still, point your neighbour to this project.

 #. However, when you give the example code to anyone else **in
    compiled form** (think programmed controller using AmForth), then
    the distribution obligations of the license for *AmForth* come in:
    be sure to provide the code of the AmForth system, the used
    example code, your modifications --- all in source form (the
    preferred representation for modification, gpl v3 section 1).
    If you cannot do this for whatever reason, AmForth is not a
    possible choice for your project.

    *Explanation:* compiling Forth code extends the Forth system in
    use. In compiled form, neither can the newly compiled functions
    (aka words) be used as an independant entity, nor are new words
    distinguishable from the words of the original Forth system in any
    way. Thus compiled Forth code always creates a *derived works* of
    the underlying Forth system, including its license. There are no
    exceptions.

 #. When you reuse the example code for some other Forth/language,
    then the license of the example code would have to be respected.
    Thus I would like to place the example code voluntarily in the
    public domain. Apparently I cannot legally do so in my
    jurisdiction, so I have to resort to `CC0 (Creative Commons Zero
    License, 1.0 unported)
    <http://creativecommons.org/publicdomain/zero/1.0/>`_.


If you find a bug in the example code, or if you think the
documentation should be enhanced or corrected, I'm happy to receive a
report.

If you find this documentation useful, or if you use the example code
for your project, I would be very interested to hear about it. If you
use AmForth, please consider contributing a link for the *Commented
Projects* Section.


Setup of Hardware
=================

The code presented here was developed and tested on an atmega-644p
controller. The AmForth system (version 6.5 at the time of writing)
has been derived from the files in ``appl/template/``. The only
changes in ``template.asm`` were the frequency of the main crystal
(``.equ F_CPU = 11059200``), the baud rate (``.set BAUD=115200``), and
as a matter of personal preference ``.set WANT_IGNORECASE = 0``. The
first two you typically have to adjust for your project anyway. The
example code should work without the third change, however, I did not
test this.


Allthough care has been taken and allthough the shown schematics work
for the author himself, the author does not garantee the shown
schematics to work under any conditions. You have to verify that
things work for you. Do not burn your house!

.. _clockworks_ingredients:

Ingredients and Clocks
======================

A microcontroller driven clock needs some means to produce a periodic
event, e.g. a timer overflow interrupt at some known frequency. This
represents the smallest meaningful unit of time on this system, let's
call this a *tick*. These *ticks* are counted to measure a *second*,
which in turn are counted to measure a *minute* and so forth. Add some
means to display the values of said counters and we do have a minimal
clock.

While this clock is definitely rather lacking in several respects, we
already run into a lengthy list of options regarding its
implementation. We have to make choices before the first line of code
is written.

   
 * :doc:`Generating Ticks from the main crystal <01_ticks_main_crystal>` ---
   this option is readily available without any additional hardware.

 * **OR** :doc:`Generating Ticks from an additional clock crystal
   <01_ticks_clock_crystal>` --- this option needs an extra crystal
   and possibly tiny load capacitors. However, it enables the
   possibility to make the controller go to sleep between ticks.

 * **OR** :doc:`Generating Ticks from an external clock source
   <01_ticks_external>` --- using an external clock source might
   provide greater long term accuracy, e.g. by using a TCXO
   (*temperature compensated crystal oscillator*) or a pps pin of a
   GPS unit.

 * :doc:`Keeping Track of Time <02_keeping_track>` using common
   counters (sec, min, hour, ...) ---
   while these counters are very common, they are not strictly
   neccessary. There could be other means to extract the common time
   format from some counter (seconds of the day, e.g.).

 * :doc:`Periodic Jobs <03_periodic_jobs>` --- I have implemented various
   parts of the clock using jobs (simple functions, really) which are
   called periodically. While this is kind of an obvious solution, it
   is not strictly neccessary.

 * :doc:`Multitasking <04_multitasking>` --- execute ``run-loop`` in
   the background. Not strictly neccessary.

 * :doc:`Display <20_display_top>` --- to see the whole thing work


Model 1: The Fairly Minimal Clock
---------------------------------

:doc:`Model 1 <40_main_fairly_minimal>` needs one version of clock
ticks, keeping track of time, the periodic jobs plus some means to
display its counters representing the time, in other words: a main
program to make the whole magic work.

-------------------------------------------------------------------

..

 * :doc:`Adding a RTC (battery backed) <06_rtc>` --- if we want to
   keep time over a power outage, we better have one of these!

 * :doc:`Accessing Shift Registers <07_shift_register>` --- accessing
   LEDs and 7-segment digits without the flicker

 * :doc:`Abakus display <21_display_abakus>` --- even more geek than binary?



Model 2: The Abakus Clock
-------------------------

:doc:`Model 2 <41_main_clock_abakus>` features a unique display and
also a battery backed real time clock to keep correct time across
power outage.

-------------------------------------------------------------------

..

 * :doc:`7-Segment LED Digits <22_display_7segment_digits>` --- a
   display with four digits. Could be expanded!

 * :doc:`Unix Epoch Seconds <05_epochseconds>` --- in order to
   implement time zones I decided to use epoch seconds. They implement
   another software clock.

 * :doc:`Time Zones <08_timezones>` --- want to display local time
   rather than UTC? This is the way to go.

Model 3: The UTC Wall-Clock
---------------------------

:doc:`Model 3 <42_main_utc_wall_clock>` features four 7-segment digits
as a display, however, they are large (70mm high) to make them
readable across the room. The concept of time zones has been added, so
daylight savings time is only flipping a switch away.

-------------------------------------------------------------------

..

 * :doc:`Small improvements for readable code <09_small_improvements>`
   --- there are a lot of functions available to write your code more
   concise. 

 * :doc:`Changing the prompt / StationID <10_prompt_ready>` --- we add
   a station ID to the code running on every board and display its
   value in the prompt. Because we can!

 * :doc:`Managing several sets of clock counters <11_clocks>` ---
   using ``structures`` will ease book keeping. Along the way we add
   labels for time zones. And we can run several such `clocks` in
   parallel, if needed.

 * :doc:`Calculating the length of a month <11_lastday_of_month>` in
   the Gregorian Calendar might be useful in its own right, so
   factored it.
   
 * :doc:`Keeping Track of Time revisited <02_keeping_track_2>` ---
   cleaning up the remaining code while using `clocks`.

 * :doc:`Creating a persisten jump table <11_persistent_jump_table>`
   --- this is a technique I have used in other places. The content of
   the jump table is calculated at compile time (in RAM) and then
   preserved in flash memory.

 * :doc:`Reading a dcf77 receiver <12_reading_dcf77>` --- this turns
   out to be quite complex and requires a lengthy chunk of code.
   

Model 4: The DCF77 controlled UTC Wall-Clock
--------------------------------------------

:doc:`Model 4 <43_main_utc_dcf77_wall_clock>` is Model 3 but with a
large software addition: the time is read from a DCF77 receiver and
periodically synchronised to the microcontrollers counters, and
optionally to the attached RTC.

Another warning: DCF77 is a central-european facility. There are
alternatives elswehere on the planet, consult `wikipedia Radio Clock
<https://en.wikipedia.org/wiki/Radio_clock>`_ for a list.


-------------------------------------------------------------------


More Stuff to come
==================

 * phase accumulator to compensate a frequency offset in ticks

 * Multitasker and simultaneous access on serial interface

 * Conversion to Unix Epoch Seconds :ref:`epoch_seconds`

 * Long term accuracy

 * Displays, also fancy ones

   This represents the visible part of the clock. Given diverse
   preferences amongst people, this is the most creative area of clock
   projects. I urge you to spend an afternoon looking at all the fancy
   clock designs, that can be found on the world wide web! This list
   cannot be complete ever, not even in categories:

   * serial interface
   * some LCDisplay --- this is a common choice
   * LEDs of 7Segment-Digits, multiplexed in some way.
   * Did I mention that I hate multiplexed displays? It hurts my eyes,
     so please use shift-registers and do away with multiplex
     blinking!
   * analog type displays
   * audio *display* for the vision impaired, or just because we can

 * Time Zones, Daylight Savings Time

 * Other Time Scales

   * Epoch seconds
   * siderial time
   * swatch beats

 * Alarm Clock


The Things Side
===============

While dealing with such a project, once in a while a number of things
must be relearned the hard way. Afterwards they are obvious, however,
while in the (code--)jungle they are not funny at all. On the other
hand, what would the world be if noone had to tell stupid stories ...


 * Cables --- There exists a subtle variation of `"is the cable connected?"`:
   Never underestimate the possibility to have more than one broken
   cable at the same time.


References
==========

 * `wikipedia: List of calendars  <https://en.wikipedia.org/wiki/List_of_calendars>`_
 * `wikipedia: Gregorian Calendar <https://en.wikipedia.org/wiki/Gregorian_calendar>`_
 * `wikipedia: Leap year          <https://en.wikipedia.org/wiki/Leap_year>`_
 * `wikipedia: Leap second        <https://en.wikipedia.org/wiki/Leap_second>`_
 * `wikipedia: Time zone          <https://en.wikipedia.org/wiki/Time_zone>`_
 * `wikipedia: Daylight saving time <https://en.wikipedia.org/wiki/Daylight_saving_time>`_
 * `wikipedia: Julian Day         <https://en.wikipedia.org/wiki/Julian_day>`_
 * `wikipedia Radio Clock         <https://en.wikipedia.org/wiki/Radio_clock>`_
 * `Unix Time (aka Epoch Seconds) <https://en.wikipedia.org/wiki/Unix_time>`_
 * `The Year 2038 Problem         <https://en.wikipedia.org/wiki/Year_2038_problem>`_
 * `wikipedia: Abacus             <https://en.wikipedia.org/wiki/Abacus>`_

 

Changes
=======

 * *2017-10-01* initial release
 * *2018-12-15* added Model 4 (UTC DCF77 clock)
   
Included Docs
=============
.. toctree::
   :maxdepth: 1

   01_ticks_main_crystal.rst
   01_ticks_clock_crystal.rst
   01_ticks_external.rst
   02_keeping_track.rst
   03_periodic_jobs.rst
   04_multitasking.rst
   05_epochseconds.rst
   06_rtc.rst
   06_rtc_pcf8583.rst
   06_rtc_ds3231.rst
   07_shift_register.rst
   08_timezones.rst
   09_small_improvements.rst
   10_prompt_ready.rst
   11_persistent_jump_table.rst
   11_clocks.rst
   11_lastday_of_month.rst
   02_keeping_track_2.rst
   12_reading_dcf77.rst
   20_display_top.rst
   21_display_abakus.rst
   22_display_7segment_digits.rst
   40_main_fairly_minimal.rst
   41_main_clock_abakus.rst
   42_main_utc_wall_clock.rst
   43_main_utc_dcf77_wall_clock.rst
   Doc_02_unixtime.rst

       
