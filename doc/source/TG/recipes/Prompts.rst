.. _prompts:

Prompts
=======

Since release 6.3 amforth has three redefinable prompt words. They
are called in the outer interpreter :command:`quit`:

.. code-block:: forth

   : quit ( -- )
      lp0 lp ! sp0 sp! rp0 rp! \ setup the stacks      
      [ \ switch to interpret mode
      begin \ an endless loop begins
        state @ 0= if .ready then
        refill if
          ['] interpret catch
          ?dup if 
            dup -2 < if .error then recurse 
          then
        else 
         .ok 
        then again ;

The :command:`.ready` is called whenever the system signals its readyness 
for input. It's default starts a new line and displays the > character. 
The definition is 

.. code-block:: forth

   USER_P_RDY Udefer .ready
   :noname ( -- ) cr ."> " ; is .ready

After this prompt, the :command:`refill` action is called when
the command line has been processed. The :command:`.ok` prompt word 
is used when the input line has been processed successfully. 
It's default displays the "ok" string

.. code-block:: forth

   USER_P_OK Udefer .ok
   :noname ( -- ) ." ok " ; is .ok

The third prompt word is called whenever the systems detects an error
or an unhandled exception. It default prints the exception number and
the position in the input buffer where the error has been detected

.. code-block:: forth

   USER_P_ERR Udefer .error
   :noname ( n -- ) ." ?? " 
      \ print the exception number in decimal
      base @ >r decimal .
      \ print the position in the input buffer
      >in @ . 
      \ restore base
      r> base !
   ; is .error

The :nonames indicate that the default actions don't have a
name in the dictionary. The defers are stored in the USER
area since all other words related to command IO are there
too. Any replacement words are expected to follow the stack 
diagrams otherwise the system may crash.
