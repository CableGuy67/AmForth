.. _clockworks_prompt_ready:

Changing the prompt / StationID
===============================

:Date: 2017-10-01

.. contents::
   :local:
   :depth: 1


Intro
-----

In the :doc:`RS485 bus project <../RS485/RS485Bus>` several boards are
connected to one bus. In order to see to which controller board
(station) exactly I am connected, I added the notion of a
``stationID``, which is displayed in the ready prompt. Since version
6.3 all prompt words are deferred so we can quite easily change them
without resorting to assembly.

This is an item in the section `because we can`.

Also see :doc:`Prompts <../../TG/recipes/Prompts>` in the Cookbook section.

Putting it all together
-----------------------

The station ID is a number ranging from ``0`` to ``127``. This
limitation comes in, because addresses on the mentioned bus are ``7``
bit wide. The value itself is stored in EEPROM

.. code-block:: forth

   #include avr-values.frt
   $007f Evalue stationID

Then we define a replacement function to print out the prompt including
the station ID (in hexadecimal notation):

.. code-block:: forth

   : .stationID_ready
     cr
     [char] ~ emit
     base @  $10 base !  stationID 2 u0.r  base !
     [char] > emit space
   ;


In order to activate this new prompt, we update the corresponding
deferred word:

.. code-block:: forth

   #include is.frt
   : init
     \ ...
     ['] .stationID_ready is .ready
   ;
   

The result looks like this:

.. code-block:: console

   > ' .stationID_ready is .ready
    ok
   ~7F> words
   .stationID_ready stationID ...
   ~7F> $0055 to stationID
    ok
   ~55> 
