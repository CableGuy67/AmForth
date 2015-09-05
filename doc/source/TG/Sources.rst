
===================
Source Organization
===================

Overview
--------

amforth is written in assembler. Only a few are actually assembly words, most
are pre-compiled forth code. There are three major directories containing the
code: :file:`avr8`, :file:`msp430` and :file:`common`. Each contain a number of
subdirectories like :file:`lib` and :file:`words` that contain actual source files.
Almost every word uses its own source file with a descriptive name. These elementary
source files are collected in include file sets, called dictionary files. Depending
on the controller type, different dictionary file sets should be used. Most of the
decisions are made automatically by using the single top-level file :file:`amforth.asm`.

The assemblers used suuport a list of include directories which is used
in order. That makes it possible to have an application specific :file:`words`
directory that may contain the same file names as the amforth provided ones that
take precedence during the assembly process. Likewise the controller specific
directories are searched before the :file:`common` directory.

Device Settings
---------------

Every Atmega has its own specific settings. They are based on
the official include files provided by Atmel and define the
important settings for the serial IO port (which port and which
parameters), the interrupt vectors and some macros.

Adapting another ATmega micro controller is as easy as
copy and edit an existing file from a similar type.

The last definition is a string with the device name in clear text.
This string is used within the word
:command:`VER`.

Application Code
----------------

Every build of amforth is bound to an application. There are a 
few sample applications, which can be used either directly (AVR
Butterfly) or serve as a source for inspiration (template
application).

The structure is basically always the same. First the file
:file:`preamble.inc` has to be included. After that some 
definitions need to done: The size of the Forth buffers, 
the CPU frequency, initial terminal settings etc. As the 
last step the amforth core is included.

For a comfortable development cycle the use of a build utility such
as :command:`make` or :command:`ant`
is recommended. The assembler needs a few settings and the proper
order of the include directories.
