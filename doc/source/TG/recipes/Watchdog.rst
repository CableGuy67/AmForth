.. _Watchdog:

========
Watchdog
========

The watchdog is a build-in module present in all atmega controllers. It
triggers a reset if for a predefined period of time nothing is done to 
prevent it.

The controller has a special machine instruction for the watchdog reset
called :command:`wdr`. Amforth has a wrapper forth word with the same name after
including the file :file:`wdr.asm`.

This word needs to be called often enough to keep the watchdog from resetting
the controller. For a system that basically waits at the command prompt the
:command:`pause` command could be sufficient:

.. code-block:: forth

   > ' wdr is pause

Initialization
--------------

Early atmega variants need to initialize the watchdog every time after
a reset, newer ones keep it active even over resets. This may cause troubles
since the WDR needs to be called much earlier for these controllers.
One solution is to place the WDR activation at the beginning of the
turnkey actions.

Watchdog Timer
--------------

Watchdog timer words, build AmForth with

:file:`wdr.asm`
  provides :command:`wdr` ( -- )   resets watchdog (wdr)

:file:`store-wdc.asm`
 provides :command:`!wdc` ( n -- ) changes WDTCSR & clears WDRF

from the :file:`avr8/words` directory. It also makes sense to 
build with :file:`sleep.asm`.

:command:`+wdt ( -- )`
   turn on  System Reset Mode

:command:`-wdt ( -- )`
  turn off System Reset Mode

:command:`+wdi ( -- )`
  turn on  Interrupt Mode

:command:`-wdi ( -- )`
  turn off Interrupt Mode

:command:`wd.delay! ( n -- )`
  write prescaler AND -wdi -wdt

include the correct constants for device
below are for atmega328p, or use the amforth-shell
script.

.. code-block:: forth

  &12 constant WDTAddr     \ Watchdog Time-out Interrupt
  &96 constant WDTCSR      \ Watchdog control register

  \             7    6    5    4   3    2    1    0
  \ WDTCSR = WDIF WDIE WDP3 WDCE WDE WDP2 WDP1 WDP0

  : +wdt ( -- ) WDTCSR c@ %00001000 or !wdc ;
  : +wdi ( -- ) WDTCSR c@ %01000000 or !wdc ;
  : -wdt ( -- ) WDTCSR c@ %00001000 invert and !wdc ;
  : -wdi ( -- ) WDTCSR c@ %01000000 invert and !wdc ;

  : wd.delay! ( n -- )
    \ !wdc is given 00?00??? to write to WDTCSR
    \ set prescaler and unset WDIE and unset WDE
    dup $7 and swap $8 and 2 lshift or !wdc
  ;

  \ From page 55 of atmega328 datasheet
  \ WDP3 WDP2 WDP1 WDP0

  %0000 constant wd.16ms 
  %0001 constant wd.32ms 
  %0010 constant wd.64ms 
  %0011 constant wd.125ms 
  %0100 constant wd.250ms 
  %0101 constant wd.500ms 
  %0110 constant wd.1s 
  %0111 constant wd.2s 
  %1000 constant wd.4s 
  %1001 constant wd.8s 

Examples
--------

.. warning:: Many of these example intentionally result in 
  your AVR8 microprocessor being reset.

.. code-block:: forth

  #include ms.frt
  #include ./wd.forth

  : ex.1 ( -- ) \ reset in 8 seconds
    wd.8s wd.delay! +wdt 8 0 ?do 1000 ms i 1+ . cr loop 
  ;

  : ex.2 ( -- ) \ use wdr to defer reset but eventually fail
    wd.4s wd.delay! +wdt 6 0 ?do wdr 1000 i * dup ms . cr loop
  ;

  \ constants for atmega328p and UNO for PIN 13 LED

  $24 constant DDRB        
  $25 constant PORTB       

  : hb.isr ( -- ) \ toggle PIN 13 on UNO
    #32 PORTB c@ xor PORTB c!
  ;

  : ex.3 ( -- ) \ interrupt only no reset and toggle an led
    #32 DDRB c@ or DDRB c!  \ set PIN13 on UNO for output
    ['] hb.isr WDTAddr int! \ load xt of word to be run on wd timeout
    wd.500ms wd.delay! +wdi \ 
  ;

  : ex.4 ( -- ) \ run after ex.3
              \ turn off watchdog interrupt and then turn on again
    -wdi 4 0 ?do 1000 ms i loop +wdi cr
  ;

use watchdog interrupt to wake from sleep
this needs an AmForth built with :file:`sleep.asm`

.. code-block:: forth

  variable snooze

  : ex.5 ( -- ) \ use watchdog interrupt to wake from deep sleep
    0 snooze !            
    ['] noop WDTAddr int! \ interrupt routine does nothing 
    wd.4s wd.delay! +wdi  \ except wake the MCU up.
    begin
        3 sleep           \ sleep 
        snooze dup @ 1+ dup . cr swap ! \ inc print store
        50 ms             \ small delay to allow print to finish
    snooze @ 5 > until    \ exit after 6 sleeps
  ;

  \ use watchdog interrupt and reset 

  #include is.frt
  #include values.frt
  #include avr-values.frt
  #include defers.frt

  variable app-reg          \ my "application" status register
  0 Evalue app-reg-save     \ persistant EEPROM store for above
                          \ to survive a reset
  : panic.isr ( -- )            

    \ wdr wasn't called in time
    \ ...
    
    app-reg @ to app-reg-save  \ store "application" status register
    #32 PORTB c@ xor PORTB c!  \ turn on PIN 13 LED

    \ will reset on next
    \ watchdog time out
    
  ;

  : ex.6 ( -- ) \ use watchdog interrupt and reset
    #32 DDRB c@ or DDRB c!            \ set PIN13 on UNO for output
    #32 invert PORTB c@ and PORTB c!  \ set PIN13 on low
    ['] panic.isr WDTAddr int!        \ load xt of word to be run on wd timeout
    0 to app-reg-save                 \ zero eeprom store of "register"
    
    wd.125ms wd.delay! +wdt +wdi

    s" Will reset in a short while. Look at app-reg-save after" itype cr
    
    250 1 ?do
        i ms wdr app-reg dup @        \ some "made up" app-reg value
        i +  swap !
    loop

    \ after the reset/power cycle look at Evalue app-reg-save
  ;
    
  : ex.7 ( -- ) \ (roughly) what frequency is my 128 kHz ?
    
    #32 DDRB c@ or DDRB c!  \ set PIN13 on UNO for output
    ['] hb.isr WDTAddr int! \ load xt of word to be run on wd timeout

    \ frequency f on PIN 13 
    \ 1 period is 2 timeouts
    \ each timeout is 2000 ticks

    \ so 2*f*2000 is roughly
    \ the frequency of my UNO's
    \ 128 kHz oscillator.
    
    wd.16ms wd.delay! +wdi

    \ I measure f to be 28.56Hz
    \ so watchdog  ~114.2kHz

    \ compare datasheet page 606
    \ for VCC=5V T=25DegC
    \ from chart ~114.2kHz
  ;

Acknowledgements
----------------

This recipe is based upon work by David Wallis and Tristan Williams
