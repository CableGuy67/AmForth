.. _clockworks_small_increments:

Small increments for better code
================================

:Date: 2017-10-01

.. contents::
   :local:
   :depth: 1


Intro
-----

Readable code is important --- you may just be the person wondering
about your source code five years from now! Sometimes there are better
ways to express your ideas.

2variables
----------

In order to increment a double variable I wrote

.. code-block:: forth

   : ++uptime ( -- )  1.  uptime 2@  d+  uptime 2! ;

While this is technically correct, I was kindly reminded that there is
a more readable way

.. code-block:: forth

   #include d-plusstore.frt
   
   : ++uptime ( -- )  1.  uptime  d+! ;

And there are more useful functions hidden in
``common/lib/forth2012/double/``, if you care to take a look (Hat tip
to Matthias).
   
   



