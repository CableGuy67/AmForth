.. _Command_IO:

==========
Command IO
==========

The standard command IO uses interrupt
driven receive and polled send. The receive
interrupt fills an 16 byte long ring buffer.
The :command:`KEY` and :command:`KEY?` words
are vectored to code that checks this buffer
and acts accordingly.

.. code-block:: forth

   : isr data-port c@ >rx-buf ;

The :command:`KEY` and :command:`KEY?`
words can check whether there are unread
characters in the buffer and act accordingly.

