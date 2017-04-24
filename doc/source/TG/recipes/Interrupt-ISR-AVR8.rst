.. _Interrupt Service Routine AVR8:

Interrupt Service Routines AVR8
...............................

.. seealso:: :ref:`Interrupt Service Routine`

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
is a simple low-level processing routine. The low-level 
generic interrupt routine stores the index of the
interrupt in a CPU register.

The inner interpreter checks *every* time it is entered the
register for a non-Null value. If it is set the interrupt processing
routine is activated. It uses the interrupt number and calculates
the index into the EEPROM based interrupt vector table. This table is 
identical to the atmega interrupt table in the flash except that it holds
the XT of the forth words that will be started for the interrupt.

.. seealso:: :ref:`Upload` to deal with the register names.
