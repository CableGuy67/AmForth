.. _User:

=========
User Area
=========

The user area is a small RAM region for task local non-stack storage.
It is basically used like variables.

The address of an user variable is built from two numbers: the user
area base address and an offset. The effective address is the sum
of both numbers. The user area base address is stored
in the user pointer UP. It can read with the ``up@`` operation and can
be modified with the ``up!`` with immediate effect.

The user pointer is different for each task. The user area size is
a parameter for task creation.

The offset handled by the developer. There is a system defined area
starting at offset 0 that is used by various amforth words. The size
of this area may change from version to version. Each architecture
directory has a file ``user.inc`` that contains the current settings.


Customize
---------

The default amforth built does not provide application specific user
area space. To get some, the application master file has to be changed
with a proper setting for the ``APPUSERSIZE`` variable. This setting 
defines the *bytes* allocated in addition to the default system user 
space.

With this new setting, new hexfiles need to be generated and uploaded.

Create
------

To create a user variable, the offset number and the name is required.

.. code-block:: forth

   > 42 user answer
   ok
   > 44 user question
   ok
   > 48 user foo

This sequence alocates a 2 byte (1 cell) space for the user variable 
``answer``, 4 bytes (2 cells) for the user variable ``question`` and 
an unspecified number of bytes (since it's the last definition) for 
the user variable ``foo``. the settings for the ``APPUSERSIZE`` shall 
be at least cover the offset 49. That is is has to be at least 
``49 - SYSUSERSIZE``.

The file ``defer.frt`` adds support for defers in the user area. They 
are used exactly like normal defers, but store the XT in the user area.

.. code-block:: forth

   > 42 Udefer answer
   ok
   > ' ver is answer
   ok
   > answer
   amforth 6.8 ....
   >

The file ``value.frt`` adds support for values in the user area. They store 
their value in the user area (instead of the EEPROM an AVR8), but behave 
identically. The definition requires both the intial value and the offset

.. code-block:: forth

   > 0 42 Uvalue answer
   ok
   > 42 to answer
   ok
   >
