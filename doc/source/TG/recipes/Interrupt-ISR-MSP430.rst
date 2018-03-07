.. _Interrupt Service Routine MSP430:

Interrupts on the MSP430
........................

Currently (version 6.5 and up) only the MSP430 G2553 
has some preliminary support for interrupt service
routines written in high level Forth. Most
of the words from the AVR world work exactly
the same way: 

.. seealso:: :ref:`Interrupt Service Routine`,
             :ref:`Interrupt Critical Section`

The ISR support is disabled by default. To enable
it, edit the application master file and add the
following line to it

.. code-block:: none

   .set WANT_INTERRUPTS = 1

Now rebuild and reflash the controller. Be aware
of the additional code space requirements and a
slightly slower overall system speed.

Currently only the G2553 supports this system.
Unlike the AVR world, not every index of the
ISR table is used actually, so a mapping is
used to minimize the code space usage.

+------------+---------------+
| Index      | Mapping G2553 |
+------------+---------------+
|   1        | Port 1 IO     |
+------------+---------------+
|   2        | Port 2 IO     |
+------------+---------------+
|   3        | ADC IO        |
+------------+---------------+
|   4        | UCSI Transmit |
+------------+---------------+
|   5        | UCSI Receive  |
+------------+---------------+
|   6        | Timer A CC1   |
+------------+---------------+
|   7        | Timer A CC0   |
+------------+---------------+
|   8        | Comparator A  |
+------------+---------------+
|   9        | Timer B CC1   |
+------------+---------------+
|   10       | Timer B CC0   |
+------------+---------------+

The XT table is stored in the Info Flash. To keep it
permanently, use the :command:`SAVE` command. All
ISR have the default action :command:`noop` and do
nothing at all.

.. seealso:: :ref:`Interrupt Service Routine AVR8`
