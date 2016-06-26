====================
Turnkey applications
====================

Turnkey application automatically execute a word upon startup.
The default turnkey action establishes the serial line communication
and prints the welcome messages (version number, cpu name, frequency).
When the turnkey action finishes, the control is handed over
to the amforth interpreter loop, which never finishes.

Turnkey itself is a deferred word. That means that it can be
changed by applying a new execution to it. Whether the turnkey
action leaves data on the stack is up to the application needs.
Turnkey is called with an empty data stack.

.. code-block:: forth

 : myinit ( -- )
   \ some code 
 ;

 \ save the xt of myinit into turnkey vector (an eeprom variable)
 ' myinit is turnkey
 
Special care must be taken if the turnkey action should not be
replaced but appended. To achieve this, the current turnkey
action has to be stored elsewhere and this execution must be
called inside the new turnkey command.

.. code-block:: forth

   \ some dependency files
   \ #include avr-values.frt
   \ #include is.frt
   \ #include ms.frt
   \ #include defers.frt

   \ keep the previous turnkey action.
   ' turnkey defer@ Evalue tk.amforth

   : tk.custom
    \ call the previous turnkey action
    tk.amforth execute

    \ now something specific e.g.
    1000 ms
    ;

    ' tk.custom is turnkey

Be aware that the initialization sequence must not
be repeated, this will create an endless loop by
calling the turnkey action inside itself.
