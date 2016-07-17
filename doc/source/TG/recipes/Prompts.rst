.. _prompts:

Prompts
=======

Since release 6.3 amforth has three redefinable prompt words. The
first one is called whenever the system signals ready for input.
It's default displays the > character. The definition is 

.. code-block:: forth

   :noname ( -- ) cr ."> " ; is .ready

After this prompt, the :command:`refill` action is called. 
The second prompt word is called if the input line has been
processed successfully. It's default displays the "ok" string

.. code-block:: forth

   :noname ( -- ) ." ok " ; is .ok

The third prompt word is called whenever the systems detects an error
or an unhandled exception. It default prints the exception number and
the position in the input buffer where the error has been detected

.. code-block:: forth

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
