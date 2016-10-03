.. _I2C Slave:

I2C Slave
=========

The TWI module of the Atmega's allows slave operations as well. Unfortunately
it is a lot more complex to setup and use. Basically an interrupt routine
does all the work needed to receive and send data.

Initialization
--------------

The I2C slave mode needs only the address. This address has to be in the
7 bit range of the i2c address space. Any address will do.

.. code-block:: forth

   > $42 i2c.slave.init

With that, an :ref:`I2C Detect` from the master's side reveals the presence
of an device at address $42.

.. code-block:: forth

   (ATmega1284P)> i2c.detect 
         0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
    0:                       -- -- -- -- -- -- -- -- --
   10:  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   20:  -- -- -- -- -- -- -- 27 -- -- -- -- -- -- -- --
   30:  30 -- -- -- -- -- -- -- -- -- -- -- -- 3D -- --
   40:  -- -- 42 -- -- -- -- -- -- -- -- -- -- -- -- --
   50:  50 51 52 -- -- -- -- -- -- -- -- -- -- -- -- --
   60:  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   70:  -- -- -- -- -- -- -- --                        
    ok

Data exchange
-------------

This section describes work-in-progress. The design may change
considerably in the future, check the actual code.

Circular buffer
...............

The I2C slave mode uses a small circular buffer for data exchange. Bytes
received are appended to it, wrapping around after 16 bytes. Every I2C
read reads from it.

On the client side there are three words: ``i2c-in`` ``i2c-out`` and
``i2c-buffer``. The last one is the base address of the i2c send/receive
buffer. The ``i2c-in`` points into that buffer at the most recently
received byte. Similarly the ``i2c-out`` points to the most recently
read byte. Both pointers wrap around if the buffer size is reached.

Direct Address
..............

TBD, Idea: send a start address and start reading from or writing
to it until NACK. The EEPROM 24Cxx protocol is probably a good starting
point.


