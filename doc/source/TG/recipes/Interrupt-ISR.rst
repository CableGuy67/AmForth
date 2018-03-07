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

Interrupts are processed in two stages. First stage
is a simple low-level processing routine. The low-level 
generic interrupt routine stores the index of the
interrupt in a CPU register.

The inner interpreter checks *every* time it is entered the
register for a non-Null value. If it is set the interrupt processing
routine is activated. It uses the interrupt number and calculates
the index into an platform specific table (AVR uses the EEPROM, the
MSP430 the index flash).
