Compiler
========

The Amforth Compiler is based upon immediate words. They are always
executed, regardless of the value in the :command:`state` variable. All
non-immediate words get compiled verbatim with their respective
execution token. It is simply appended to the current DP location.

Immediate words are usually executed (unless some special action such
as :command:`postpone` is applied). The immediate words do usually
generate some data or compile it to the dictionary. They are not
compiled with their execution token.

There are no optimization steps involved. The XT are written immediately
into the dictionary (flash).

The inner interpreter, the forth virtual machine, can, just like a real CPU, 
only execute words, one after the next. This linear control flow is usually 
not sufficient to do real work. The Forth VM needs to be redirected to other
places instead of the next one, often depending on runtime decisions.

Since Edsgar Dijkstra the structured programming is the preferred way to do it. 
AmForth provides all kinds of them: sequences, selections and repetitions. Sequences
are the simple, linear execution of consecutive words. Selections provide a conditional
jump over code segments. They are usually implemented with the :command:`ìf` command. 
Multiple selections can be made with :command:`case`. Repetitions can be unlimited or 
limited. Limited Repetitions can use flags and counter/limits to leave the loop.

There is also support for out-of-band control flow: Exceptions. They provide
some kind of emergency exits to solve hard problems. They can be catched at any
level up to the outer text interpreter. It will print a message on the command
terminal and will wait for commands.

Building Blocks
---------------

All control structures can be implemented using jumps and conditional jumps. 
Every control operation results in either a forward or a backward jump. Thus
6 building blocks are needed to create them all: :command:`(branch)`,
:command:`(0branch)`, :command:`>mark`, :command:`<mark`, :command:`>resolve`
and :command:`<resolve`. None of them are directly accessible however. Most
of these words are used in pairs. The data stack is used as the control flow
stack. At runtime the top-of-stack element is the flag. All words are used in 
immediate words. They are executed at compile time and produce code for the 
runtime action.

:command:`(branch)` is a unconditional jump. It reads the flash cell after the
command and takes it as the jump destination. Jumps can be at any distance
in any direction. :command:`(0branch)` reads the Top-Of-Stack element and
jumps if it is zero (e.g. logically FALSE). If it is non-zero, the jump is not 
made and execution continues with the next XT in the dictionary. In this case, 
the branch destination field is ignored. These two words are implemented in 
assembly. A equivalent forth implementation would be

.. code-block:: forth

   : (branch) r> 1+ @i >r ;
   : (0branch) if (branch) else r> 1+ >r then ;

Note the chicken-and-egg problem with the conditional branch operation.

Contrary the MSP430. Its inner interpreter uses *relative* branches instead.
That influences the next higher level word internally, but does not affect
words using them.

The :command:`mark` words put the jump destination onto the data stack. This
information is used by the :command:`resolve` words to actually complete the
operation. The :command:`<mark` additionally reserves one flash cell.
The :command:`<resolve` stores the information for the backward jump
at the current location of the dictionary pointer, the :command:`>resolve`
places the information at the place the :command:`>mark` has reserved and
completes the forward jump. Every mark needs to be paired with the *right*
resolve.

.. code-block:: forth

   : >mark dp -1 , ;
   : >resolve ?stack dp swap !i ;

   : <mark dp ;
   : <resolve ?stack , ;

The place holder -1 in :command:`>mark` prevents a flash erase cycle when the
jump is resolved using the :command:`!i` in :command:`>resolve`. The
:command:`?stack` checks for the existence of a data stack entry,
not for a plausible value. It the data stack is empty, an
exception -4 is thrown.

.. code-block:: forth

   : ?stack depth 0< if -4 throw then ;

Highlevel Structures
--------------------

The building blocks described above create the standard control
structures: conditional execution and various loop constructs.

The conditional execution compiles a forward
jump to another location. The jump destination
is resolved with :command:`then`. An :command:`else`
terminates the first jump and starts a new one for the
final :command:`then`. This way an alternate code block
is executed at runtime depending on the flag given to
the :command:`if`.

.. code-block:: forth

   : if   postpone (0branch) >mark ; immediate
   : else postpone (branch)  >mark swap >resolve ; immediate
   : then >resolve ; immediate

There is a rarely used variant of the :command:`if` command, that compiles
an unconditional forward branch: :command:`ahead`. It needs to be paired with
a :command:`then` to resolve the branch destination too. An
:command:`else` would not make any sense, but is syntactically ok.

.. code-block:: forth

   : ahead postpone (branch) >mark ; immediate

There are more variants of multiple selections possible. The
:command:`case` structure is based upon nested :command:`if`'s. Computed
goto's can be implemented with jump tables whith execution tokens as code
blocks. Examples are in the :file:`lib` directory.


The loop commands create a structure for repeated execution of
code blocks. A loop starts with a :command:`begin`
to which the program flow can jump back any time.

.. code-block:: forth

   : begin <mark ; immediate

The first group of loop command are created with :command:`again` and
:command:`until`. They basically differ from each with the branch
command they compile:

.. code-block:: forth

   : until postpone (0branch) <resolve ; immediate
   : again postpone (branch) <resolve ; immediate

The other loop construct starts with :command:`begin` too. The
control flow is further organized with :command:`while` and
:command:`repeat`. :command:`while` checks wether a flag is true
and leaves the loop while :command:`repeat` unconditionally repeats 
it. Multiple :command:`while` 's  are possible, they have to be
terminated properly with a :command:`then` for each of them (except
the one, which is terminated with the :command:`repeat`.

.. code-block:: forth

   : while postpone (0branch) >mark swap ; immediate
   : repeat again >resolve ; immediate


Counted loops repeat a sequence of words for some predefined
number of iterations. It is possible to exit prematurely. The
standard loop checks for the exit condition after the loop body
has been executed. A special variant (?DO) does it once at the
beginning and may skip the loop body completely. To actually
implement the loop and its possible exit points a separate LEAVE
stack (named after the LEAVE forth word) is used at compile time.
It receives all premature exit points which are resolved when
compiling LOOP (or +LOOP).

.. code-block:: forth

   : endloop 
    <resolve \ standard backward loop
    \ now resolve the premature exits from the leave stack
    begin l> ?dup while postpone then repeat ;

   : do postpone (do) <mark 0 >l ; immediate
   : loop postpone (loop) endloop ;  immediate
   : +loop postpone (+loop) endloop ; immediate
   : leave postpone unloop postpone ahead >l ; immediate

:command:`unloop` is an assembly word dropping the loop 
counter and loop limit information from the return stack.

The :command:`?do` works differently. It uses the 
:command:`do` and the leave stack to achieve its 
goals. 

.. code-block:: forth

   ... ?docheck if do ... loop then ....

The helper word :command:`?docheck` checks the loop 
numbers and creates a well prepared stack content.

.. code-block:: forth
    
    \ helper word
    : ?docheck ( count limit -- count limit true | false )
	2dup = dup >r if 2drop then r> invert ;

    : ?do postpone ?docheck 
        postpone if \ here we create the forward branch
        postpone do \ initialite leave stack
	swap >l     \ put the IF destination on the leave stack
    ; immediate

The runtime action of :command:`do` (the :command:`(do)`)
puts two information onto the return stack: The modified loop
counter abd  the loop limit. The loop index and the loop limit
are modified by adding 0x8000 to both numbers. That makes
it easy to check the boundary cross required by Forth by simply
checking the controller overflow check. The price to pay is
a slightly slower access to the loop index (I and J).

The runtime of :command:`loop` (the :command:`(loop)`)
checks the limits and with :command:`0branch` decides whether to
repeat the loop body with the next loop counter value or to exit
the loop body. If the loop has terminated, it cleans up the return
stack. The :command:`+loop` works almost identically, except that
it reads the loop counter increment from the data stack.

The access to the loop counters within the loops is done with :command:`i`
and :command:`j`. Since the return stack is used to manage the loop runtime,
it is necessary to clean it up. This is done with either :command:`unloop`
or :command:`leave`. Note that :command:`unloop` does not leave the loop!

DOES>
-----

:command:`DOES>` is used to change the runtime
action of a word that :command:`create` has already 
defined. Since the dictionary is in flash which may
only be written once, the use of :command:`create` is
should be replaced with the command :command:`<builds`.
This commands works exactly the same way but enables
:command:`does>` to work properly.

Its working is described best using a
simple example: defining a constant. The standard
word :command:`constant` does exactly the
same.

.. code-block:: console

  > : con <builds , does> @i ;
   ok
  > 42 con answer
   ok
  > answer .
   42 ok

The first command creates a new command :command:`con`. With
it a new word gets defined, in this example :command:`answer`.
:command:`con` calls :command:`create`, that parses the source
buffer and creates a wordlist entry :command:`answer`.  After that,
within :command:`con` the top-of-stack element (42) is compiled into
the newly defined word. The :command:`does>` changes the
runtime of the newly defined word :command:`answer` to the code
that follows :command:`does>`.

:command:`does>` is an immediate word. That means, it is not compiled
into the new word (con) but executed when con gets compiled. This compile
time action creates a small data structure similar to the wordlist entry 
for a noname: word. The address of this data structure is an execution 
token. This execution token replaces the standard XT that a wrongly
defined :command:`con` (using create instead of builds) would have
written already. This leads inevitably to a flash erase cycle, that
may not be available on all platforms.
