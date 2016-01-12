============
Architecture
============

Overview
--------

amforth is a 16 bit Forth implementing the indirect threading
model. The flash memory contains the whole dictionary. The RAM
contains buffers, variables and the stacks. Depending on the
platform, either the EEPROM or a special section of the flash
is used for vital data such as pointers or configuration settings.

The compiler is a classic compiler without any optimization
support.

Amforth uses all of the CPU registers internally: The
data stack pointer, the instruction pointer, the user pointer, and
the Top-Of-Stack cell. The hardware stack is used as the return
stack. Some registers are used for temporary data in primitives.


Text Interpreter
----------------

The interpreter is a line based command interpreter. It based upon 
::command:`REFILL` to acquire the next line of characters, 
located at a position :command:`SOURCE` points to. While processing 
the line, the pointer :command:`>IN` is adjusted accordingly. Both
words :command:`REFILL` and :command:`SOURCE` are USER based 
deferred words which allows to use any input source on a thread 
specific level. The interpreter itself does not use any static 
buffers or variables (:command:`>IN` is a USER variable as well).

A given string is handled by :command:`INTERPRET` which splits it
into whitespace delimited words. Every word is processed using a 
list of recognizers. Processing ends either when the string end is 
reached or an exception occurs.

SOURCE and REFILL
.................

:command:`SOURCE` provides an addr/len string pair that does not 
change during processing. The task of :command:`REFILL` is to fill
the string buffer, :command:`SOURCE` points to when finished.

There is one default input source: The terminal input buffer. 
This buffer gets filled with :command:`REFILL-TIB` that reads 
from the serial input buffers (:command:`KEY`). :command:`SOURCE` 
points to the Terminal Input Buffer itself. Another input source 
are plain strings, used by :command:`EVALUATE`.

.. _Recognizers:

Recognizer
..........

Recognizer are a part of the text (command) interpreter.
They are responsible for analyzing a single word. The
result consists of two elements: The actual data (if any)
and an object like identifier connected with certain methods.

.. digraph:: Recognizer
   :inline:

   "Interpret" -> "Get Next Word"
   "Get Next Word" -> "Do Recognizer" [label="Got one"]
   "Get Next Word" -> "End" [label="No More Words"];
   "Do Recognizer" -> "Check State"
   "Check State" -> "Compile" [label="Compile"];
   "Check State" -> "Execute" [label="Interpret"];
   "Compile" -> "Get Next Word"
   "Execute" -> "Get Next Word"

The Forth text interpreter reads from the input source 
and splits it into whitespace delimited words. Each word
is fed into a list of actions which parse it. If the
parsing is successful (e.g. it is a number or a word from
the dictionary) the recognizer leaves the data and
an method table to deal with it. Depending on the
interpreter state one of the methods is executed to
finally process the data. The first method is called
in interpreter state. It is usually a noop, since
the recognizer has done all the work already.

The 2nd method is responsible to perform the compile
time semantics. That usually means to write it into
the dictioanary or to execute immediate words.

The third method is used by :command`postpone` to compile the
compilation semantics. It honors the immediate flags as well.

``Do Recognizer`` is an iteration over a recognizer
stack until the first parsing methods returns something
different than :command:`r:fail`. If the recognizer stack is
exhausted without a match, the :command:`r:fail` return value
is generated. The string location that is passed to the 
parse actions is preserved and is restored for every iteration
cycle.

.. digraph:: DoRecognizer
   :inline:

   "Get Recognizer Stack" -> "Rec-Stack Exhausted?"
   "Rec-Stack Exhausted?" -> "R:FAIL"  [label="Yes"]
   "Rec-Stack Exhausted?" -> "Call Parse Action"  [label="Consume Rec-TOS"]
   "Call Parse Action" -> "Rec-Stack Exhausted?" [label="R:FAIL"]
   "Call Parse Action" -> "End" [label="Success"]
   "R:FAIL" -> "End"

A recognizer consists of a few words that work together.
To ease maintenance, a naming convention is used: The
recognizer itself is named with the prefix ``rec:``. The
method table name gets the prefix ``r:`` followed by
the same name as the recognizer.

:command:`POSTPONE` serialises the parsed data as literals and
adds the compile action from the method table. This an
almost generic operation, it depends only on the number
of cells from the parsing actions.

Recognizer List
~~~~~~~~~~~~~~~

The interpreter uses a list of recognizers. They are managed
with the words :command:`get-recognizers` and :command:`set-recognizers`.

The entries in the list are called in order until the first 
one returns a different result but :command:`r:fail`. If the list
is exhausted and no one succeeds, the :command:`r:fail` is delivered
nevertheless and leads to the error reactions.

The standard recognizer list is defined as follows

.. code-block:: forth

   : default-recs
     ['] rec:intnum ['] rec:word
     2 forth-recognizer set-recognizers
   ;

The standard word :command:`marker` resets the recognizer list as well.

INTERPRET
~~~~~~~~~

The interpreter is responsible to split the source into words
and to call the recognizers. It also maintains the state.

.. code-block:: forth

   : interpret
     begin
       parse-name ?dup if drop exit then
       forth-recognizer do-recognizer ( addr len -- i*x r:table )
       state @ if i-cell+ then \ get compile time action
       @i execute ?stack
     again
   ;

:command:`do-recognizer` always returns a valid method table. If no
recognizer succeeds, the :command:`r:fail` is returned with the addr/len
of the unknown-to-handle word.

API
~~~

Every recognizer has a method table for the interpreter to handle 
the data and a word to check (and convert) whether a string matches
the criteria for a certain data type.

.. code-block:: forth
   
   \ order is important!
   :noname ... ;  \ interpret action
   :noname ... ;  \ compile action
   :noname ... ;  \ postpone action
   recognizer: r:foo

   : rec:foo ( addr len -- i*x r:foo | r:fail ) ... ;

The word :command:`rec:foo` is the actual recognizer. It analyzes the
string it gets. There are two results possible: Either the word
is recognized and the address of the method table is returned
or a failure information is generated which is actually a predefined
method table named :command:`r:fail`.

The calling parameters to :command:`rec:foo` are the address and 
the length of a word in RAM. The recognizer must not change it. 
The result (i*x) is the parsed and converted data and the method
table to deal with it.

There is a standard method table that does not require
additional data (i*x is empty) and which is used to communicate
the "not-recognized" information: :command:`r:fail`. Its method
table entries throw the exception -13 if called.

Other pre-defined method tables are :command:`r:intnum` to deal 
with single cell numeric data, :command:`r:intdnum` to work with
double cell numerics and :command:`r:find` to execute, compile 
and postpone execution tokens from the dictionary.

The words in the method tables get the output of the recognizer 
as input on the data stack. They are excpected to consume them 
during their work.

Default (Fail)
~~~~~~~~~~~~~~

This is a special system level recognizer. It is
never called actually but its method table (r:fail) 
is used as both a error flag and for the final error 
actions. Its methods get the addr/len of a single 
word. They consume it by printing the string and 
throwing an exception when called. The effect is 
to get back to the command prompt if catched 
inside the :command:`quit` loop.

.. code-block:: forth

   :noname type -13 throw ; dup dup
   recognizer: r:fail

   \ this definition is never called actually
   : rec:fail ( addr len -- r:fail)
     2drop r:fail
   ;

NUMBER
~~~~~~

The number recognizer identifies numeric data in both
single and double precision. Depending on the actual
data width, two different methods tables are returned.

The postpone action follows the standard definitions with
not allowing to postpone numbers. Instead the number is
printed and an exception is thrown.

.. code-block:: forth

   ' noop
   ' literal
   :noname . -48 throw ; \ subject to dispute
   recognizer: r:num

   ' noop
   ' 2literal
   :noname d. -48 throw ; \ subject to dispute
   recognizer: r:dnum

   : rec:intnum ( addr len -- n r:num | d r:dnum | r:fail )
     number if
      1 = if r:num else r:dnum then
     else 
       r:fail
     then
   ;


FIND
~~~~

This recognizer tries to find the word in the dictionary. If
sucessful, the execution token and the flags are returned. The
method table contains words to execute and correctly deal with
immediate words for compiling and postponing.

.. code-block:: forth

   ( XT flags -- )
   :noname drop execute ; 
   :noname 0> if compile, else execute then ; 
   :noname 0> if postpone [compile] then , ; 
   recognizer: r:word

   : rec:word ( addr len -- XT flags r:word | r:fail )
     find-name ?dup if
       r:word
     else
       r:fail 
     then
   ;

Multitasking
------------

amforth does not implement multitasking directly. It
provides the basic functionality however. Within IO
words the deferred word :command:`PAUSE` is called 
whenever possible. This word is initialized to do 
nothing (:command:`NOOP`).

.. _ExceptionTable:

Exceptions
----------

Amforth uses and supports exceptions as specified in the
ANS wordset. It provides the :command:`CATCH`
and :command:`THROW` commands. The outermost catch
frame is located at the interpreter level in the word
:command:`QUIT`. If an exception with a negative value is
catched, :command:`QUIT` will print a message with this
number and and re-start itself. Positive values silently
restart :command:`QUIT`.

The next table lists the exceptions, amforth uses itself.

+-----------+---------------------+---------------+
| Exception |         Meaning     | Thrown in     |
+-----------+---------------------+---------------+
|    -1     |  silent abort       | ABORT         |
+-----------+---------------------+---------------+
|    -2     |  abort with message | ABORT"        |
+-----------+---------------------+---------------+
|    -4     |  stack underflow    | ?STACK        |
+-----------+---------------------+---------------+
|   -13     |  undefined word     | rec-notfound, |
|           |                     | tick          |
+-----------+---------------------+---------------+
|   -16     |  Invalid word       | (create)      |
+-----------+---------------------+---------------+
|   -50     |  search order       | SET-ORDER     |
|           |  exhausted          |               |
+-----------+---------------------+---------------+
