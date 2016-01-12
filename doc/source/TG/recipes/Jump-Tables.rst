
===========
Jump Tables
===========

:Author: Erich Wälde

Summary: store precomputed values in a flash table / constructing a jump table

I wanted to store precomputed values in a permanent table. In one case
the values were precomputed by evaluating a special declaration syntax.
In the other case a list of :command:`:noname ... ;` Definitions  were 
going to be accessed through a (jump) table.

For the second problem I wrote down something like

.. warning:: does not work, please continue to read for the solution!

.. code-block:: forth

  create Table
    :noname  1 VarA +! ;  ,
    :noname  2 VarA +! ;  ,
    ... 

This is not only naive, but also wrong: I'm mixing the compiled code with
the XTs to be stored. So the table did contain the XTs in the wrong
places mixed with the corresponding code. Once I understood this, I came
up with the idea to generate the code and store the XTs in a RAM table
first, and then copy the table from RAM to FLASH. Additionally, the table
was initialised with :command:`noop` as default value, since several entries
remained *empty*, i.e. had nothing to do. I could have pushed the XTs on
the stack, but with >50 entries this did not seem correct to me. Here we
go:

First we define the length of the final table in *entries* and allocate
the corresponding RAM space and proved a function to fill it with default
values (:command:`fill` would not help here, because :command:`fill` copies 
bytes rather than cells):

.. code-block:: forth

   variable SomeVar  \ variables needed by the code snippets should
   variable OtherVar \ go BEFORE variable T.ram

   #10 constant T.len
   variable T.ram T.len cells allot
   : T.init
     ['] noop
     T.len 0 do dup T.ram i cells +  ! loop
     drop 
   ;

The RAM space can be *released* after producing the flash table, even
though :command:`T.ram` continues to exist as a word.

When compiling the :command:`:noname` code snippets (think *anonymous functions*),
we want to store the freshly generated XT at a given location in the ram
table. A separate word makes the source code look nice (provisions
against index overflow were added):

.. code-block:: forth

   : >T.ram ( xt idx -- )
     dup 0 T.len within if
       cells T.ram + !
     else
       drop \ or throw
     then
   ;

To copy the content of :command:`T.ram` to a new table in flash, the following
function will do the work. In expects the number of items and the source
address on the stack and consumes the next token of the source code as
name for the new table.

.. code-block:: forth

   : >ftable ( srcaddr len -- ) ( ccc.name )
     create  ( consumes ccc.name )
     ( len ) 0 do
       ( srcaddr ) dup  i cells +  @  ,
     loop
     ( srcaddr ) drop
     does>  \ fixme: needed???
   ; 

Now we are equipped to compile the anonymous functions and store the XTs
in :command:`T.ram`:

.. code-block:: forth

   T.init

   :noname  #1 SomeVar +! ;        #3 >T.ram  \ function for field #3
   :noname  #8 SomeVar +! 
            #1 OtherVar ! ;        #4 >T.ram  \ function for field #4 

Note that the *anonymous functions* can be of arbitrary length. The
order, in which the fields in :command:`T.ram` is filled, is irrelevant. 
It is not neccessary to fill all fields, since they all were initialized 
with the XT of :command:`noop`.

After the table is prepared to our liking, we copy it to flash:

.. code-block:: forth

   T.ram T.len >ftable T.flash

The new, permanent table is called :command:`T.flash` in this example. We can now
release T.ram with

.. code-block:: forth  

   T.ram to here

provided we did *not* define any other variables in the meantime. The XTs
in :command:`T.flash` can be called like this:

.. code-block:: forth

   : T.run ( index -- )
     dup 0 T.len within if
       ( index ) T.flash +  @i  execute
     else
       drop \ or throw
     then
   ; 


