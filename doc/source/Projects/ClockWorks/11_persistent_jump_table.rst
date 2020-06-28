.. _clockworks_persistent_jump_table:

Persistent Jump Table
=====================

:Date: 2018-11-11

.. contents::
   :local:
   :depth: 1


Intro
-----

The cookbook section holds an explanation, how persistent
`Jump tables <http://amforth.sourceforge.net/TG/recipes/Jump-Tables.html>`_
can be constructed.


The table used in the inner workings of the DCF clock has the
following features:

 - there are #60 entries, some unused

 - the functions called will consume one item from the stack

 - the default action should then be ``drop`` rather than ``noop``

 - the stored functions are accessed `exclusively` through the table,
   their name is not needed. So the will be defined using ``noname:``



Creating the RAM table
----------------------

First we create the temporary RAM table by simply alloting 60 cells:

.. code-block:: forth

   \ create temporary RAM table
   variable dcf.tmp.table #60 cells allot

Then we add the XT of ``drop`` as default:

.. code-block:: forth

   ' drop dcf.tmp.table #60 ramtable.init


At this point we have a valid RAM table, allthough it will not lead
to much useful action as is.


To simplify the code generating the table, we add a `short hand` to
store a given ``XT`` at position ``idx`` in the RAM table just defined.

.. code-block:: forth

   : >rt ( xt idx -- )  dcf.tmp.table >ramtable ;


Creating noname: functions, storing their XTs in the RAM table
--------------------------------------------------------------

Just for the sake of the argument we define a word, which is lighting
up an LED, if the value on the stack is non-zero.

.. code-block:: forth

   :noname ( x -- )
     if    ( not zero )  led.0 on
     else  ( zero )      led.0 off
     then
   ;  #31 >rt

This function is then added at index ``#31`` into the RAM table.

Whatever the behaviour of the newly defined function, all we know is
that ``:noname`` will leave the XT on the stack, and ``>rt`` will pick
that (and the index) up and place the XT in the RAM table at index
``#31``.

**Please Note:** There should be no allocation of RAM space during
this stage. All needed variables must be defined before alloting the
temporary table. Beware of defining words! If we can stick to this
rule, we can sort of `release` the RAM afterwards.

In the code this section is much longer of course. We will see more
details in section :doc:`Reading a dcf77 receiver <12_reading_dcf77>`.


Preserve the precious new content
---------------------------------

After defining all the needed words and filling the RAM table, we want
to preserve the precious new content.

.. code-block:: forth

   dcf.tmp.table #60 >flashtable cmd_map

This will define a new word ``cmd_map``, which will leave the address
of its parameter section on the stack, just like an ordinary variable.
The parameter section will hold the saved content.


Release the space of the temporary RAM table
--------------------------------------------

If we got this far, and if we did not allocate any RAM space **after**
the temporary RAM table, the we can release it by boldly resetting the
``here`` pointer

.. code-block:: forth

   dcf.tmp.table to here

If funny, bad, or inexplicable things happen while running your code,
disable this step and see, if it changes the behaviour. Just in bloody
case.



Using the preserved table at last
---------------------------------

The particular jump table in this case is used to call the correct
function after a second has passed. It will get the value of the
received DCF Bit and deal with it according to its position in the
telegram.


Using the above table is a matter of fetch and execute:

.. code-block:: forth

   : pos.cmd ( index -- )
     dup 0 #60 within if
       ( position ) cmd_map +  @i execute
     else
       drop
     then
   ;

Somewhere in your code you will add the value to be consumed onto the
stack, add the index into the jump table on top and call ``pos.cmd``.


Putting it all together
-----------------------

The code lines give above are bracketing the lengthy section of code,
which defines all the functions needed to handle a DCF77 telegram.


.. code-block:: forth

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
   \ ;                                     #idx >rt
   \ :noname
   \     drop ( always ) ...
   \ ;                                     #idx >rt

   \ #0   always 0
   :noname
     \ ...
   ;                                         #0 >rt

   \ ... more definitions here ...

   :noname
     \ ...
   ;                                        #58 >rt

   \ dcf.tmp.table #60 ramtable.dump \ DEBUG
   \ copy RAM table to FLASH
   dcf.tmp.table #60 >flashtable pos_cmd_map
   \ release RAM
   \ WARNING: there might be dragons around!
   \          Iff so, disable the next line
   Dcf.tmp.table to here

   : pos.cmd ( index -- )
     dup 0 #60 within if
       ( position ) pos_cmd_map +  @i execute
     else
       drop
     then
   ;
