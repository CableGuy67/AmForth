.. _clockworks_multitasking:

Multitasking
============

:Date: 2017-08-09

.. contents::
   :local:
   :depth: 1

Intro
-----

For **increased geek factor:** we can connect to our clock over serial!

A clock program can definitely be the only thing that runs on the
microcontroller which is the heart and brain of our clock. However,
since I (and hopefully you, too) use AmForth on the controller, I do
not want to give up connecting to the running clock to inspect, how
things are going, or to correct/configure things. Interactivity is too
nice to give it up. That being said, one more piece is needed to
execute the code of the clock (keeping track of time and the periodic
jobs) *in the background*, namely the multitasker.

If you have never used Forths cooperative multitasker, go reading up
(:ref:`Multitasking`) in the Cookbook section. I'll wait, no problem.

The multitasker revolves around some pieces of per-task information,
residing in the task control block, and a linked list of these blocks.
The function ``pause`` in a task releases the CPU just now and lets
the next task in the list resume.




Design Decisions
----------------

 * There will be two tasks:

   **Task1** running the command loop at the serial connection, in
   other words *the shell*

   **Task2** running ``run-masterclock``, such that all work regarding
   the clock is done *in the background* and does not interfere with
   *the shell*

 * More tasks are certainly possible, but not needed so far.

 * for Task2 a ``task:`` named ``task-masterclock`` is defined

 * this task is activated in function ``start-masterclock``. There
   could be more such starter functions, so I wanted it to remain
   small and separate

 * in ``starttasker`` all extra tasks are started
   (``start-masterclock``) and linked into the list of task control
   blocks (``task-masterclock tib>tcb alsotask``). At last the
   multitasker ist started (``multi``).



Putting it all together
-----------------------

This part needs a few code lines in the main program.

.. code-block:: forth

   \ --- multitasker
   #include multitask.frt
   : +tasks  multi ;
   : -tasks  single ;
   
   : run-masterclock
     begin
   
       tick.over? if ... then
       ...
   
       pause
     again
   ;
   $40 $40 0 task: task-masterclock \ create task space
   : start-masterclock
     task-masterclock tib>tcb
     activate
     \ words after this line are run in new task
     run-masterclock
   ;
   : starttasker
     task-masterclock task-init            \ create TCB in RAM
     start-masterclock                     \ activate tasks job
   
     onlytask                              \ make cmd loop task-1
     task-masterclock tib>tcb alsotask     \ start task-2
     multi                                 \ activate multitasking
   ;


At the prompt enter::

  > init starttasker

and the show should start. Get a list of tasks with::

  > tasks





