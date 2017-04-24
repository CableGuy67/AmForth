.. _Interrupt Service Routine:

Interrupt Service Routines
..........................

An interrupt can occure any time. Interrupts are
handled with standard forth words. They must not
have any stack effect. 

The interrupt forth word is executed within the context 
of the current user area and stack frame. Using ``throw`` 
is not recommended since it will affect the user area of 
the interrupted task.

:command:`+int` ( -- )
  enable the interrupt handling globally

:command:`-int` ( -- )
  disable the interrupt handling globally

:command:`int@` ( n -- XT )
  fetch the XT of the interrupt service routine
  for interrupt n

:command:`int!` (XT n -- )
  store the XT as the handler for interrupt n.
  This has immediate effect.

:command:`int-trap` ( n -- )
  simulate interrupt n
