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

.. code-block:: forth

 \ TIMER_0 example
 \
 \ provides
 \  timer0.tick      -- increasing ticker
 \
 \ older mcu's may need
 \  TCCR0 constant TCCR0B
 \  TIMSK constant TIMSK0

 variable timer0.tick

 : timer0.isr
   1 timer0.tick +!
 ;

 : timer0.init ( preload -- )
    0 timer0.tick !
    TCNT0 c! \ preload
    ['] timer0.isr TIMER0_OVFAddr int!
 ;

 \ some settings for 8bit timer to
 \ get 1ms ticks
 \ f_cpu  prescaler preload
 \  16MHz   64       6
 \   8MHz   64     131

 : timer0.start
    0 timer0.tick !
    %00000011 TCCR0B c! \ prescaler 64
    %00000001 TIMSK0 c! \ enable overflow interrupt
 ;

 : timer0.stop
   %00000000 TCCR0B c! \ stop timer
   %00000000 TIMSK0 c! \ stop interrupt
 ;

All interrupts are available for forth interrupts. 

``int!`` (and friends) uses the interrupt address from
the data sheet as an index, but points to a different address in EEPROM.

Interrupts are processed in two stages. First stage
is a simple low-level processing routine.

#. The low-level interrupt routine stores the index of the
   interrupt in a RAM cell (not directly accessible from
   amforth).
#. Sets the T-flag in the status register to signal the inner interpreter
   that an interrupt needs attention.

The inner interpreter checks *every* time it is entered the
T-flag. If it is set (1) the interrupt processing
routine is activated. It reads the number of the interrupt and calculates
the index into the RAM based interrupt vector table. This table is identical
to the atmega interrupt table in the flash except that it holds
the XT of the forth words that will be started for the interrupt.

.. seealso:: :ref:`Upload` to deal with the register names.
