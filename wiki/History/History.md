History
=======

24.8.2016: release 6.3
----------------------

-   core(AVR8): Use the standard Interrupt Service Routine for terminal
    input too. Makes re-definable with **int!**. Thanks to Erich for his
    longanimity on this and the prompt defers.
-   core(MSP430): Use the hardware multiplier if available.
    Add **n>r** and **nr>**.
-   lib(ALL): Chains: Lists of execution tokens.
-   core(ALL): The three prompt words are now system USER based defers:
    **.ready** for the \>,
    **.error** if an error occured and
    **.ok** if everything was fine. See
    **prompts** for more.

4.7.2016: release 6.2
---------------------

-   core+lib(MSP430): New optional assembly (compile-time) words
    **d2*** and **d2/**.
-   core(ALL): renamed **find-name ( addr len -- xt +/-1 | 0)** to **find-xt**,
    compare to **find-name ( addr len --  nt|0)** to deal with name tokens.
-   core(MSP430): add **pause** to the usart IO words.
-   core(ALL): complete recognizer *broken link removed*
    adaption.
    This pdf link didn't exist anywhere I could find but I do belive it referred
    to this proposal. [Proposal: \[142\] Recognizer](https://forth-standard.org/proposals/recognizer#contribution-142)

17.10.2015: release 6.1
-----------------------

-   core(ALL): Adapt **postpone** action
    of the recognizers to comply with [Proposal: \[142\] Recognizer](https://forth-standard.org/proposals/recognizer#contribution-142).
    Change your recognizers accordingly.
-   core(MSP430): New devices MSP430 F5529 (Flash) and FR5969 (FRAM).
    See **TI_Launchpad_430**.
-   core(MSP430): Extended VM Register A. See
    **Extended-VM**
-   lib(ALL): Fix regressions in **Rdefer** and **does>**. Make quotations more
    robust in corner cases.

6.9.2015: release 6.0
---------------------

-   core(ALL): Fix a few regressions like the TAB handling in **accept**.
-   core(AVR8): Fix **forth-wordlist** to return a valid wordlist id.
-   core(MSP430): many small changes to bring it closer to the AVR8.
    Still fits into 8KB flash.
    -   global variables like **DP**, (**HERE**), **STATE**, **HLD** etc instead
        of USER variables.
    -   Same USER area layout. Including deferred words for terminal IO.
    -   complete wordlist support including search order and current.
    -   Emulate AVR EEPROM configuration with a info flash segment.
        Needs **save** to store the data permantly.
    -   Lots of common code, optimized versions of standard words if applicable.
    -   preparing for more MSP430 device types.

9.7.2015: release 5.9
---------------------

-   lib: **for** and **next**. The **i** and **j** can be used as well.
-   core(AVR8): clear all RAM at **cold**.
-   core(MSP430): **DEFER** and **VALUE** were missing in release 5.8.
    **pause** and **turnkey** using them (RAM based, save-able to info flash).
-   core(All): **'** uses the recognizer stack.
-   core(ALL): Fix regression in **literal** (broke e.g. quotations)

25.3.2015: release 5.8
----------------------

-   core(MSP430): new **:noname** and the **defer** and **value** groups of commands.
-   core(All): words with the same name do the same (mostly).
-   core(AVR8): introduce **<builds**. Together with **does>** saves one flash
    erase cycle and makes the source work on the MSP430 as well.

1.2.2015: release 5.7
---------------------

-   core(ALL): **name>interpret** and **name>compile** added. New Recognizer
    **rec:name** able to replace **rec:word**. Uses name tokens (Forth 2012)
    instead of execution tokens.
-   core(ALL): Lots of bugfixes and regressions. The AVR port should be fully
    usable again.
-   core(MSP430): restructure of the init process:
    **cold** now transfers the data from INFO flash back to RAM if BASE is set
    and **SAVE** was executed. That way the user code now correctly survives a
    restart. **SAVE** is much like marker that overwrites the previous state and
    gets no name.

22.12.2014: release 5.6
-----------------------

-   core(AVR): **icompare** got the same return flag semantics as **compare**.
    The **leave** and **?do** forward branches are now resolved at compile time,
    saves one cell per loop on the return stack at runtime.
-   core(AVR): interrupt vectors are moved from RAM to EEPROM. Saves RAM space
    and simplifies turnkey actions *(remove any **int!** from your turnkey!)*
-   core: re-arranged source files: controller specific and common code.
-   New architecture: MSP430 (G2553) as used in the **TI_LaunchPad_430** with
    code from [Camelforth](http://www.camelforth.com) and [4€4th](https://web.archive.org/web/20120501132848/http://www.somersetweb.com/4E4th/EN.html).
-   core: generalized existing **Stacks** in EEPROM into **map-stack**,
    **get-stack** and **set-stack**. Used for the search order and recognizer stacks.
-   all: changed license to GPLv3.

6.10.2014: release 5.5
----------------------

-   core: Bugfix in **warm** to initialize the interpreter for **turnkey**.
    Thanks to David.
-   core: bugfixes for handling some negative numbers in **+loop** and ***/**.
-   core: simplified assembly primitves for counted loops. They are now faster
    except for **i**. The return stack gets different numbers now.
-   core: rewrite of **accept**. The user visible change is that the final CR/LF
    is no longer sent here. The forth text interpreter does it elsewhere thus the
    user interface is unchanged.
-   core: Fixed a regression introduced after 5.1:
    a\<b is not always the same as a-b\<0.

16.8.2014: release 5.4
----------------------

-   lib: Almost complete **Blocks** wordset support. Only a few dark corners
    behave differently.
-   lib: renamed TWI to I2C, added many tools for it **I2C Values**,
    **I2C EEPROM Blocks** and a few more.
-   recipes: [Test Driven Development](http://en.wikipedia.org/wiki/Test-driven_development) with **Amforth <Testing>**, **Conditional Interpret**
-   lib: Fully support the ANS94 String wordset.
-   core: Double cell return stack access words (**2>r** and **2r>**) missed
    the internal swap\'s. Added new **2r@**.
-   lib: Limited LOCALs

7.5.2013: release 5.3
---------------------

-   core: 2nd generation of **Recognizers** and their use for native
    **String literals <Recognizer>**.
-   core: renamed **edp** to **ehere**. **here** points to data space, **ehere**
    points to eeprom data space.
-   core: merged code for defer\'s and value\'s. Speed improvements for defer
    actions.
-   community: MMC/SD-Card from Lubos (So Sorry for beeing late) and TCP/IP
    (**Telnet**). Many Thanks to Jens. Speed optimized words for SPI in amforth core.
-   doc: [Japanese Getting
    Started](http://amforth-installation-ja.readthedocs.org/ja/latest/index.html)
-   doc: new recipes: **Forward**, **Extended-VM**, **Quotations**, **Exceptions**,
    **Coroutines**, updated recipes: **SPI**, **Ardiuno Helloworld**

23.12.2013: release 5.2
-----------------------

-   Improved and extended **Values**
-   Forth 2012 [Traverse-Wordlist](http://www.forth200x.org/traverse-wordlist.html)
-   improved documentation
-   core: added **d0=** and **0=** as assembly primitives and use them in other
    compare operations. Saves a lot of code space.
-   Wordlist entries are now 8bit clean. Words with umlauts or e.g. Greek commands
    work as expected, unless the terminal does not cooperate. Thanks to Enoch.

    ```Forth
    > : Σ  0 swap 0  do  +  loop  ;
     ok
    > 7 8 9 3 Σ .
      24  ok
    >
    ```

5.4.2013: release 5.1
---------------------

-   core: Automatic scoping of words. A system hook can be used to use a
    different wordlist than CURRENT to place a new word in. Thanks to Enoch for
    the idea and the code.
-   lib: very flexible CRC8 checksum generator and checker. Thanks to Enoch.
-   recipes: **Interrupt Critical Section**, **Unbreakable**,
    **Efficient Bitmanipulation**, **Dump Utilities**, **Ctrl-C** Thanks to Enoch
    and the others on the mailing list for code and inspiration.
-   core: **-int** does no longer leave the SREG register. It only turns off the
    global interrupt flag. Thanks to Enoch.
-   lib: major 1-wire enhancements: CRC checks and a better naming convention for
    all words. Thanks to Erich for help and substantial contributions.
-   appl: added the Arduino Leonardo. avrdude needs a small patch to write
    properly the eeprom on the Atmega32U4.
-   core: New **popcnt** (n \-- m) counts the [Hamming Weight](http://en.wikipedia.org/wiki/Hamming_weight)
    of the given number.
-   core: renamed **baud** to **ubrr**.
-   core: **nfa>lfa** is a factor in a number of words. It generates the link
    field address from a given name field address.
-   doc: Farewell docbook XML, welcome reST. All documentation will be written
    in [reStructured Text](http://sphinx-doc.org/).
-   lib: Simple Quotations. Their typical use case is

    ```Forth
    : foo ... [: bar baz ;] ... ;
    ```

    which is equivalent to

    ```Forth
    :noname bar baz ; Constant#temp#
    : foo ... #temp# ...;
    ```

27.12.2012: release 5.0
-----------------------

-   lib: Access to **1-Wire**. Based on code and ideas by Bradford J. Rodriguez
    for the [4€4thproject](http://www.4e4th.eu).
-   lib: many Arduino ports have more than one purpose. The forth200x
    [Synonym](http://www.forth200x.org/synonym.html) gives them useful alias names.
-   Arduino: Added definitions for all ports based upon **Digital Ports**.
-   recipes: There are now more than 30 **Cookbook** in the cookbook: many debug
    tools, loop with timeout, porting from C, and interrupts to mention some of them.
-   core: autogenerate **sleep** depending on register availability. **sleep**
    on an Atmega32 is very different from an Atmega328p. The parameters for
    calling it at the forth level are the same however. The include list for the
    assembler is expanded with **core/<device>/** to find the right **sleep.asm** file.
-   core: rudimentary error checks in the compiler: There has to be branch
    destination on the stack. If there is nothing, a stack underflow exception
    gets thrown.

    ```Forth
    > : ?do i . loop ;
    ?? -4 14
    > : t2 ?do i . loop ;
     ok
    >
    ```

-   core: Number sign may follow the number base prefix as specified in
    [Forth200x Number Prefix](http://www.forth200x.org/number-prefixes.html).
    Added the character \# as prefix for decimal as well.
-   core: fixed a regression in **toupper** caused by making **within** standards
    compliant. Thanks to Arthur for the fix. **[compile]** fixed as well.

27.7.2012: release 4.9
----------------------

-   core: initialisation of the USER area is now done in WARM. please
    check your TURNKEY to remove the call to it. Thanks to Erich for
    pointing to.
-   core: regenerated the devices files with the part description files
    from studio v6. added bitnames to the forth and python modules
    (later to be used with the shell).
-   tools: completly new shell program with cool upload features from
    Keith:
    [amforth-shell](http://amforth.svn.sourceforge.net/viewvc/amforth/trunk/tools/amforth-shell.py?view=log)
    It has command completion, full command history, automatic
    controller identification with all register names and much more.
    Updated the **Upload** for this task
-   lib: re-arranged source files, improved timer modules.
-   lib: **case** did not work at all.
    Thanks to Jan for telling.
-   core: the new variable **latest**
    has the XT of the currently being defined colon word.
-   core: **unused** should tell the
    free amount of memory in the area **here** points to: RAM. Thanks to Carsten for the hint.
-   core: introducing an environment query for basic controller
    information: memory sizes, max dictionary address:
    **mcu-info**. The structure itself
    is not yet finalized. See at the end of a
    [core/\<device\>/device.asm
    \<http://amforth.svn.sourceforge.net/viewvc/amforth/trunk/core/devices/atmega328/device.asm?view=markup\>]()
    file for details.
-   tools: The upload utilities were unable to process absolute
    filenames (those beginning with a /) Thanks to Carsten for the fix.

26.3.2012: release 4.8
----------------------

-   core: fixed a bug in **na@** and
    **nb@** (extended VM registers).
-   core: redesigned **to** for use in
    LOCALs and RAM-based values.
-   core: **.s** is stripped down to a
    single line output of the stack content only. Looks better in the
    call tracer and is more like other forth\'s.
-   core: small atxmega updates. Unfortunatly avrdude cannot flash the
    boot loader section as expected.
-   core: optional Unified memory address space. **@** and **!** use the
    range from 0 to RAMEND as RAM, from RAMEND+1 upwards the next
    addresses from EEPROM, until EEPROMEND is reached and the remaining
    addresses from flash.
-   core: **environment?** can now be
    used in colon definitions. changed into loadable forth source
    instead of compile-time assembly.
-   core: **itype** now sends proper
    (e.g. single byte) characters to **emit**.
-   core: **type** is made more robust
    against **emit** errors.
-   lib: **macro** and a
    **Defining and using Macros** recipe for
    using them.
-   **Profiler** to count the number of
    calls.
-   lib: **evaluate** for both RAM and
    Flash based strings.

4.2.2012: release 4.7
---------------------

-   recipes: **Multitasking**,
    **Reason For Reset** and
    **Tracer**
-   core: new words from the STRINGS word set:
    **sliteral** and
    **compare**. Latter is a simplified
    version of the ANS94 spec: max 255 chars, (in)equality tests only.
-   core: **source**,
    **refill** are now deferred words,
    based on the USER area. **>in**
    likewise. Based on ideas from [Strong
    Forth](http://home.vrweb.de/stephan.becher/forth/doc/chapter11.htm).
-   core: **/key** removed, it can be
    implemented by changing **refill**.
-   lib: The multitasker could not work after power cycles. Thanks to
    Erich for fixing.

6.10.2011: release 4.6
----------------------

-   core: **words** shows the *first*
    entry in the search order list as specified by DPANS94.
-   lib: new word **m*/** (d1 n1 n2 \--
    d2), uses a triple cell intermediate for d1\*n1.
-   lib: new words **bm-set**,
    **bm-clear** and
    **bm-toggle** that efficiently
    change bits in RAM byte addresses. e.g.
    ** %0010 here bm-toggle** changes
    bit 2 in the RAM location at **here**.
-   lib: renamed **spirw** to
    **c!@spi**, new word
    **!@spi** exchanges two bytes via
    SPI. Follows remotly the memory access word naming conventions.

29.6.2011: release 4.5
----------------------

-   arduino: re-arranged word placing to maximize usable flash (at least
    on a duemilanove device, the bigger variants like the sanguino and
    mega\* still have room for improvement). The target mega is now
    called mega128.
-   lib: **lib/buffer.frt** implements
    [buffer:](http://www.forth200x.org/buffer.html).
-   doc: improved refcard. Thanks to Erich for input and patches.
-   core: changed API of the [Recognizer](/pr/Recognizer-en.pdf) to the
    final addr/len pairs. Do not use counted strings any longer!
-   core: new words **find-name** and
    **parse-name** follow [Forth
    200x](http://www.forth200x.org/parse-name.html) and operate on the
    current input buffer, **word** is no
    longer used internally. Lots of internal code simplifications.
-   core: **(create)** throws exception
    -16 if no name is given.
-   core: exception -42 is really -4 (stack underflow).
-   core: **digit?** again. Stack effect
    now compatible to gforth:
    **( char -- n true | false)**.
    Current setting of **base** is now
    taken internally.

24.5.2011: release 4.4
----------------------

-   examples: added a game of life and a queens puzzle solver.
-   core: restructure of the RAM usage. You need to remove the
    **.set here = ...** line from your
    application definition file (template.asm).
-   core: turn **cold** into the main
    initialization word and **warm**
    into some high level initialization.
-   doc: updated Technical Documentation of Recognizers and Interrupt
    Processing. Reformatted the **RefCard**
    to a more compact style.
-   core: added **n>r** and
    **nr>** from [Forth
    200x](http://www.forth200x.org/n-to-r.html).
-   core: Redesign of Interrupt Handling. ISR Routines are still normal
    Colon Words and can deal with every kind of interupts. There are no
    lost interupts any longer. Based on Ideas from Wojciech (Tracker
    ID 2781547) and Al (mailling list).
-   appl: Fixed a regression in the floating point library due to
    changes in **number** in post 4.0
    releases. **>float** can now be used
    as the main part of a recognizer.
-   core: added a compile time option WANT\_IGNORECASE to make amforth
    case-insensitve, disabled by default.

1.5.2011: release 4.3
---------------------

-   core: **u>** had wrong stack effect
    in case of true result.
-   core: **int-trap** triggers an
    interrupt from software.
-   core: **/user** environment query
    gives the size of the USER area
-   core: **sleep** takes the sleep mode
    as parameter.
-   ex: added timer-interrupt.frt as an example for using interrupts
    with forth.
-   pub: Erich has presented amforth at the Fosdem 2011
    [Slides](/pr/Fosdem2011-slides-amforth.pdf) and
    [Proceedings](/pr/Fosdem2011-proceedings-amforth.pdf) (published
    with permission). Thanks Erich!
-   core: simplified **get/set-order**
    with a changed eeprom content.
-   doc: new user guide version from Karl (for version 4.2).
-   core: renamed **e@/e!** to
    **@e/!e** to comply with the memory
    access wordset from forth200x, same with **i@/i!**.
-   core: documentation fixes in many files: **RefCard**.
-   core: re-design of the (outer) interpreter using recognizers
    (dynamically extend the interpeter to deal with new semantics.
    Defined **get/set-recognizer**
    similiar to **get/set-order**.

19.9.2010: release 4.2
----------------------

-   core: fixed a regression for **i!**
    which made **marker** useless (among
    other oddities). Thanks to Marcin for the fix
-   core: currently defined colon words are invisible until the final ;.
-   applications: Leon contributed a IEEE754 floating point library in
    plain forth, Pito translated some basic words into assembly for
    speed.

2.9.2010: release 4.1
---------------------

-   core: new words **2>r**,
    **2r>** and
    **2literal**.
-   core: converted most of the atmega part definition files with the
    pd2amforth utility. Please report any success / failure.
-   doc: set the fuses to make the bootloader size as large as the NRWW
    size.
-   core: abort assembling if flash usage is above limits.
-   core: allow double cell numbers in colon definitions. Thanks to Pito
    for reporting the bug.

1.7.2010: release 4.0
---------------------

-   tools: amforth-upload.py optionally loads a device specific module
    and replaces register definitions with their values prior to sent
    the code to the controller. The device modules are auto-generated
    from the part description files.
-   core: ANS94 mention that HERE points to the data (RAM) region.
    Re-introduced DP as the dictionary (Flash) pointer.
    **HEAP** is gone. Migrate old HEAP
    to HERE and old HERE to DP.
-   core: save and clear the initial value of the MCU Status Register at
    address 10.
-   tools: pd2amforth is now capable to generate the device definition
    files. It is no longer necessary to edit them manually.
-   core: finally separated the terminal IO settings from the device
    definition files.
-   core: optionally set **WANT_SPI** (or any other IO Module) to include
    the register definion names at build time.
-   core: massivly restructured the **devices/** filesystem entry. Change your application files to
    include **device.asm** instead of the
    device name. Set the include directory to the proper subdirectory
    under **core/devices** as well.
-   core: dynamically calculate the free space. Do not use all of it
    however, the data stack may grow.

```Forth
s" /pad" environment?
```

-   core: Simplified the Pictured Numeric Output words. They now use the
    memory area below **pad** (which is
    100 bytes above HEAP) as the buffer region.
-   appl: added the arduino board with some example codes. Currently
    with the Mega (Atmega1280), Duemilanove (Atmega328) and Sanguino
    (Atmega644p) controller types.

25.5.2010: release 3.9
----------------------

-   web: updated the Howto page to demonstrate
    **Redirect IO**.
-   core: The Atmega2561 now fully works (incl the compiler).
-   core, appl: Andy Kirby donated the device files and a full
    implemention for Arduino Mega with the Atmega1280.
-   core: CPU Name, Forthname and Version strings can be accessed as
    environment queries.

25.4.2010: release 3.8
----------------------

-   core: turned **i!** into a deferred
    word.
-   core: fix for **icompare** to make
    it work with all addr/len strings. Bug found and fixed by Michael
    and Adolf.
-   core: re-implemented the **i!** in
    (mostly) assembly language to ease integration into bootloaders.
-   core: factor the three prompts into compile time changable words.
-   appl: the **dict_minimum.inc** und
    **dict_core.inc** files need to be
    included within the application defition files.
-   core: **pad** is no longer used by
    amforth itself.
-   core: reorder internal code in **interpret** to get rid of **0=**
    calls.

24.1.2010: release 3.7
----------------------

-   core: atxmega 128 support (no compiler yet).
-   core: new word **>number**.
    **number** accepts trailing (!) dots
    to enter double cell numbers.
-   lib: enhanced multitasker with turnkey support. Thanks to Erich
    W&auml;lde for in depth debugging and testing.
-   lib: new word **anew** drops word
    definitions if already defined, starts a new generation.
-   core: USER area is now split into system and application user areas,
    system user area is pre-set from EEPROM.
-   new: source repository
    [Incubator](http://amforth.svn.sourceforge.net/viewvc/amforth/incubator/)
    for not-yet-ready-but-interesting projects, volunteers welcome.

1.10.2009: release 3.6
----------------------

-   core: new word **environment**. It
    provides the environment wordlist identifier, thus make it possible
    to create own environment queries as standard words.
-   core: new word **d=**.
-   core: amforth runs partially on an atmega2561 and atxmega\'s, there
    is still no working flash store word (**i!**) therefore only the interpreter is available yet.
-   core: moved the usart init values to appl section.
-   core: added a poll-only receive word, selectable at compile time.
    Disable the rx interrupt to use it.

1.9.2009: release 3.5
---------------------

-   core: re-structure the usart code, added a non-interrupt based
    transmit word (TX), selectable at compile time.
-   lib: added **xt>nfa** that goes from
    the XT to the name field address.
-   core: bugfix **recurse**.
-   core: restructured EEPROM, never depend on fixed addresses for
    system values.
-   core: added a **dict_wl.inc** file with
    most of the non-core wordlist commands.

11.4.2009: release 3.4
----------------------

-   core: renamed the words for the serial terminal to be more generic
    since they can deal with any serial port, not only the first one.
-   lib: dropped **forget** since it
    cannot work with multiple wordlists, fixed
    **marker**.
-   core: changed again **digit?** stack
    effect (and fixed a little bug).
-   core: **number** honors a leading *&*,
    *\$* or *%* sign to temporarily switch to DECIMAL, HEX or BIN base resp.
    Thanks to Michael Kalus for factoring the code.

22.2.2009: release 3.3
----------------------

-   core: faster **noop**.
-   added ANS94 search order wordlist.
-   core: **within** had problems with
    signed boundaries, literal numbers are processed faster (again).
-   core: improved **digit?** and
    **number**. They now report errors
    on invalid characters at the wrong position. The following strings
    are no longer valid numbers: \--1 or 0@ (in base hex).
-   core: **-1 spaces** now prints
    nothing, Fix from Lothar Schmidt.
-   core: **(loop)** (runtime of loop)
    now checks for equality only, as specified in ANS94.

10.1.2009: release 3.2
----------------------

-   core: bugfix for trailling 0x00 byte during
    **itype**.
-   core: enable use of other usart port than 0.
-   pc-host: [Ken
    Staton](http://staton.us/electronics/remote_IO/atmega_bit_whacker.html)
    wrote a nice pc based terminal with upload functionality.
-   core: New controllers: ATmega328P and ATmega640.
-   core: changed **digit** to
    **digit?** found in many other
    forth\'s.
-   core: new word **within**.
-   core: split application dictionary definition into 2 parts, one for
    the lower flash, one for the upper (NRWW) flash. Both can be empty,
    but need to exists.
-   core: changed some names for internal constants (baudrate -\> BAUD)
    and registers (EEPE vs EEWE).
-   core: new directory **drivers/** for
    low level driver functions. Currently only the generic ISR and the
    USART0 interrupt handler.

10.11.2008: release 3.1
-----------------------

-   core: **icompare** now has a
    similiar stack effect as **compare**.
-   core: new word: **environment?**.
    Supports **/hold** query.
-   core: Strings in flash (incl. names in the dictionary) contain now
    16bit length information, previously only 8 bit.

17.10.2008: release 3.0
-----------------------

-   core: **s"** new with interpreter
    semantics.

```Forth
s" hello world" type`
```

works at the command prompt. The compiled version is

```Forth
: hw s" hello world" itype ;
```

-   core: Placement of Stacks is now an application setting. See example
    apps.
-   core: added VM register A and B. See [Stephen Pelc\'
    Slides](http://www.complang.tuwien.ac.at/anton/euroforth/ef08/papers/pelc.pdf)
    for details. Uses Atmega Register R6:R7, R8:R9 resp.
-   core: added **cmove** as a primitve.
-   core: **f_cpu** used the old
    (pre-2.7) stack order for double cell values.
-   lib: moved some definitions to more appropriate files.

1.8.2008: release 2.9
---------------------

-   core: **heap**,
    **here** and **edp** are now VALUEs. **dp** is gone (use **here**)
-   lib: more VT100 sequences.
-   core: The TIB location and size are accessible with the VALUEs
    **TIB** and **TIBSIZE**.
-   core: fixed TIBSIZE default configuration.
-   lib: created math.frt, contains among others the standard words
    **sm/rem**,
    **fm/mod**.
-   Alexander Guy fixed a bug in **u*/mod**.
-   Bernard Mentink adapted Julian Noble\'s Finite State Machine code.
-   applications: Lubos Pekny designed a smart computer with a 4line
    character LCD and a PS/2 keyboard. Details are in the [Application Repository](http://amforth.svn.sourceforge.net/viewvc/amforth/applications),
    a video is
    [available](http://www.forth.cz/Download/App/LCD+KbdPS2.avi) as
    well.

27.6.2008: release 2.8
----------------------

-   core: Lubos Pekny found that **-jtag**{.interpreted-text
    role="command"} sometimes used the wrong mcu register.
-   core: Bernard Mentink wrote a Atmega128 device file, Thanks alot.
-   core: Atmega88 & Atmega168 work too.
-   core: Fixed regression for atmega128.
-   core: Moved serial interface words to application dictionary (not
    every amforth installation may have a serial terminal).
-   library: Updated assembler from Lubos Pekny.
-   examples: sieve benchmark, optimized for 1K RAM.

5.4.2007: release 2.7
---------------------

-   core, lib and sample applications are now in one package.
-   restructured repository layout. Now the trunk has most of the
    sources.
-   core: re-arranged the register mapping.
-   core: **m*** was in fact
    **um***.
-   core: double cell numbers changed stack order: TOS is now the most
    significant cell.
-   library: new: assembler written by Lubos Pekny,
    [www.forth.cz](http://www.forth.cz). Thank you!
-   examples: PWM example from Bruce Wolk. TWI/I2C EEPROM access

27.1.2008: release 2.6
----------------------

-   core: new defining words **code**
    and **end-code**.
    **code** starts a new dictionary
    header with the XT set to the data field. The 2nd one appends the
    **jmp NEXT** call into the
    dictionary.
-   core: removed the pre-assembled **case** / **endcase** words.
    Added them as forth library.
-   core: new words **-jtag** (turns off
    JTAG at runtime) and **-wdt** (turns
    off watch dog timer at runtime. They need to be implemented as
    primitives due to timing requirements.
-   core: **quit**: Keep
    **base** when handling an exception.
-   library: TWI/I2C EEPROM Support.

6.12.2007: release 2.5
----------------------

-   Bug: **hex 8000 .** froze the
    controller. Now it prints -8000. Thanks to Lubos for the hint.
-   Moved init of **base** from
    **quit** to **cold**. **turnkey** be used
    to change it permanently. Thanks to Lubos for the hint.
-   nice looking dumper words for RAM/EEPROM/FLASH, dropped idump.asm.
-   Extended Upload utility (**tools/amforth-upload.py**) from piix: include files using following syntax:

```Forth
\ demo file
#include ans94/marker.frt
marker empty
```

-   usart transmit (**tx0**) made more
    robust.
-   User Area restructured for the new multitasker.
-   added documentation: Karl\'s **User Guide** and a **Technical Guide**.

11.10.2007: release 2.4
-----------------------

-   Added AT90CAN128. Other Atmega128 style controllers should work too.
-   lot of fine tuning.
-   dropped the assembler device init portion.
-   New file: **dict_compiler.inc**.
    Without these words the forth system is (more or less) a pure
    interactive system without extensibility.
-   new words **[char]**,
    **fill**.
-   re-arranged usart code. fixed bug when usart baud rate calculation
    leads to values greater 255.
-   renamed **/int** to
    **-int** and **int** to **+int**, it\'s
    more fortish ;=)

29.7.2007: release 2.3
----------------------

-   new words **spaces** and
    **place**.
-   Improved **i!**.
-   bugfixing runtime parts of **do**/**loop** and co.
-   re-coded **find** and
    **icompare** for better readability.
-   eliminated code duplets in some primitives.
-   moved usart init from **cold** to
    application specific turn key action. Added error checking in
    receive module.

17.6.2007: release 2.2
----------------------

-   new download section: application
-   optional dictionary is now part of the application, therefore
    renamed to **dict_appl**.
-   new words: **leave** and
    **?do**.

22.5.2007 release 2.1
---------------------

-   changed stack effect for **#** to
    ansi (from single cell value to double cell). Double cell values do
    not work (yet).
-   introduced **deferred** words
    instead of tick-variables. Works for EEPROM based vectors (turnkey),
    RAM based (**pause**) and User based
    (**emit** etc) vectors.
-   new words: **wdr** (Watchdog reset),
    **d>** and **d<**{.interpreted-text
    role="command"} (double cell compare).

2.5.2007 release 2.0
--------------------

-   internal restructure of targets.
-   new words: **u>** and
    **u<**.
-   bugfixing interrupts.
-   new word: **log2** logarithm to base
    2, or the number of the highest 1 bit.
-   fixed wrong addresses for usart-io (esp. butterfly)

25.4.2007 release 1.9
---------------------

-   renamed **dict_low.asm** to
    **dict_minimal.asm**.
-   new word **parse** ( c \-- addr len)
    parses **source** for char delimited
    strings.
-   new word **sleep** ( \-- ) puts the
    controller into (previously defined) sleep mode.
-   new words **s"** ( \-- addr len)
    parses TIB for \" character and compiles it into flash,
    **s,** ( addr len \-- ) does the
    real copying of the string into flash at **here** together with the invisible word
    **(sliteral)** (\-- flash-addr len).
-   bugfix: **f_cpu** had wrong word
    order. Use **swap** as a temporary
    work around.
-   re-wrote initialisation of usart0 ( baud \-- ) to forth code.
    Startup speed is taken from (eeprom) VALUE **baud0**{.interpreted-text
    role="command"}.

10.4.2007 release 1.8
---------------------

-   interrupt handling redesigned. Now every interrupt (except those for
    usart0) can be used. **intcounter**
    is gone. New words are **int@**,
    **int!** and
    **#int**.
-   double and mixed cell arithmetics.
-   bugfix: proper initialization of data stack pointer. Thanks to
    Maciej Witkowiak.
-   move TOS into register pair.

3.4.2007 release 1.7
--------------------

-   new word: **f_cpu** sets a double
    cell value with the cpu clock rate.
-   **hld** is now at
    **pad** to save RAM.
-   **pad** did return some compile-time
    stochastic value
-   lots of internal changes.
-   optional dictionary: **d-**,
    **d+**, **s>d** and **d>s**.

25.3.2007 release 1.6
---------------------

-   split **blocks/ans.frt** into pieces.
-   **sign** no longer inserts a space
    for non-negative values.
-   new word: **/key**. It is vectorized
    via **'/key** and gets called by
    **accept** to signal the sender to
    stop transmission. See **blocks/xonxoff.frt** for example usage.
-   replaces **up** with
    **up@** and **up!**.
-   new word: **j** ( \-- n).
-   new word: **?execute** ( xt\|0 \-- )
    if non-zero execute the XT.
-   The Atmega644 works fine :=) but needs the Atmel assembler (see
    **FAQ**) :=(
-   Bugfix: **+!** did a
    **+** only.
-   Bugfix: too many spaces in **.**
    (dot).
-   give user variables **rp** and
    **sp** a name.

14.3.2007 release 1.5
---------------------

-   changed: **itype** and (new)
    **icount** refactored by Michael
    Kalus. These words now have similiar stack effects as there RAM
    counterparts.
-   changed: **.** now operates on
    signed values.
-   new word: **u/mod** is basically the
    former **/mod**.
-   new word: **u.** to display unsigned
    values.
-   fixed bug in **/mod** for values
    less -FF (hex).
-   **create** left the address of the
    XT insted of the PFA. Fixed.
-   deleted word: **idump**. It is now
    in the file **blocks/misc.frt**.
-   new word: **:noname** ( \-- xt)
    creates headerless entry in the dictionary.
-   new word: **cold** as main entry
    point. It executes the turnkey action. **abort** & co do not trigger the turnkey action.

5.3.2007 release 1.4
--------------------

-   **pad** is now in the unsed
    (according to **heap**) ram. That
    may help **word** to store longer
    strings.
-   new word: **unused** ( \-- n) gives
    the number of unused flash cells in the dictionary.
-   **/mod** (and **/** and **mod**) now
    honor signed numbers, division is symmetric.
-   new word: **abort"**
-   **quit** now aborts on every catched
    exception.
-   **quit** no longer prints anything,
    **ver** is now a turnkey action.
-   new optional dictionary, included at compiletime. Contains now
    **case** & Co and some
    **d-** words for double cell
    arithmetics.

24.2.2007 release 1.3
---------------------

-   bug: **digit** did not work properly
-   bug: **<**: equal is not less
-   interrupts are processed faster
-   Interrupt counter are now only 1 byte long (access with
    **c@**)
-   change: **allot** works now for ram
    not for flash
-   added/corrected stack comments
-   bug: **create** leaves flash address
    insted of first cell content
-   change: **.s** nicer for empty stack
-   internal: **i!** internally
    completly turns off interrupts
-   bug: **abort** now works again,
    error was in **quit**
-   bug: **while** and
    **repeat** changed stack effects
-   bug: **r@** now works correctly
-   new word: **immediate**
-   removed words: **forget**,
    **postpone** (these and many more
    are now in the **blocks/ans.frt**
    library)
-   bug: if **'** (tick) does not find
    the word, it now throws the exception -13 Many thanks to Ulrich
    Hoffmann for providing feedback and corrections!

3.2.2007 release 1.2
--------------------

-   anyone missed **emit?**?.
-   increased user area to 24 bytes (12 cells). Fixed a overlap between
    **handler** and
    **emit** ff.
-   AVR **AVR Butterfly** works (again).
    Many thanks to the [German FIG](http://www.forth-ev.de/) for
    donating one.
-   internal changes for multitarget development (for the AREXX asuro
    minirobot).

20.1.2007 release 1.1
---------------------

-   **emit**, **key** and **key?** are now
    vectored via **user** based
    variables.
-   **forget** frees most of the flash
    space too
-   internal go back for **i!** to
    previous code
-   Code for Atmega8 was broken due to nrww flash overflow (found by
    Milan Horkel)
-   Bugfix: backspace key in **accept**
    now stops at beginning of line (found by Milan Horkel)

4.1.2007 release 1.0
--------------------

-   new immediate word: **[']**
-   new word **user** defines user
    variables
-   new controller: atmega169 (Atmel Butterfly)
-   renamed **eheap** to
    **edp**.

17.12.2006 release 0.9
----------------------

-   interrupts in high level forth colon words (INT0 and INT1 for now).
-   new word: **noop** a colon word for
    doing nothing.
-   **number** respects minus sign
-   changed **turnkey** into
    **'turnkey**. The
    *turn-off* value is now 0 (zero)
-   new words: **pause** and
    **'pause**.
    **pause** will execute the XT stored
    in **'pause** (a RAM cell) when non
    zero
-   **handler** (used by
    **cactch** and
    **throw**) is a USER variable.

7.12.2006 release 0.8
---------------------

-   new words: **create**,
    **does>**, **up**, **0**
-   Support for user variable, turned **base**, **rp0** and
    **sp0** into user variables
-   words like **(do)** which should not
    by called by user are now invisible to save nrww flash space
-   bugfix for negative increment for **+loop**.

24.11.2006 release 0.7
----------------------

-   new word: **turnkey**: executed
    whenever **quit** starts.
-   numbers may contain lower case characters (if
    **base** permits)
-   bugfixing **case** & co.
-   **number** emits -13 if an invalid
    character is found
-   renamed **vheader** to
    **(create)**
-   **abort** re-initializes both stacks
-   made backslash **\\** immediate

20.11.2006 release 0.6
----------------------

-   backspace now works in **accept**
-   **depth** based on
    **sp0**/**sp@**
-   \"unused\" control characters are treated as spaces
-   bugfixes for **(loop)** and
    **(+lopp)**.
-   New words: **1ms** busy waits 1
    millisecond

13.11.2006 release 0.5
----------------------

-   definition files for varios atmega types
-   core wordlist should be complete
-   internal cleanups and bugfixes

5.11.2006 release 0.4
---------------------

-   start using **catch**/**throw**
-   Atmega8 works fine
-   few new words (**case**, comments)
-   nicer prompt

31.10.2006 release 0.3
----------------------

-   New website
-   Atmega16 works fine
-   Bugfixing, true flag always 0xffff

27.10.2006 release 0.2
----------------------

-   Compiler works
-   Many new wrds

16.10.2006 release 0.1
----------------------

-   first public release
-   interpreter over serial terminal
