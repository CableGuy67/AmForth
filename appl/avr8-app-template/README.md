## QUICK START

This is the basic avr8 application template that can be used as a starting
point for your own app. Just make a copy of this file and rename it to match
your project.

Once that is done you can rename the ***app_name.asm*** file to match your
application name or to anything that you might want. You just need to change
the  **TARGET** variable in the makefile to match. This is also a useful way to
build multiple versions in the same directory if, for example, you want to
build with both avra and avrasm2 or just to have a handy backup.

The _**app_name.asm**_ file has a couple things that may need to be changed.
The first is the *MCU clock speed* which defaults to an *8MHz* setting:

```Assembly
; amforth needs two essential parameters: CPU clock
; and command terminal line.
; cpu clock in hertz, 1MHz is factory default
.equ F_CPU = 8000000
```

The other is the *BAUD* for the serial connection. Make sure this matches your
serial terminal setting that you use to connect to the MCU. Most likely you
will just need to remove the semicolon in the `.set BAUD` line and change it to
match what you are using.

```Assembly
; serial line settings. The defaults are set in avr8/preamble.inc.
; You should not change that file but use your own settings *here*
; since it may get changed in future versions of amforth.
;.set BAUD=38400
;.set BAUD_MAXERROR=10
;.set WANT_ISR_RX = 1 ; interrupt driven receive
;.set WANT_ISR_TX = 0 ; send slowly but with less code space
```

There are a good deal of settings in that file that can deal with pretty much
anything for a successful build.

In the makefile there are a number of things to set depending on if you are
using linux or windows, if you want to use avra or avrasm2, your fuse setting
etc. It is pretty well documented so it should be easy to figure out what to
fill in.

Once everything is set just do 'make' to build your project and/or avra. As
noted in the makefile after the first build removing the 'yes' from **MAKE_AVRA** will stop building and cleaning avra each time you make/make
clean. Leaving **USING_AVRA** blank will use avrasm2 as the assembler. This
can be coupled with the **USING_WINE** setting to use either assembler with
either linux or windows.

The ***build.xml*** file is for ant(elope) and may be removed in the future
since I don't use ant nor know if it is even still working correctly.
