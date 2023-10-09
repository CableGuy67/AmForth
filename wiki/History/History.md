History
=======

24.8.2016: release 6.3
----------------------

-   core(AVR8): Use the standard Interrupt Service Routine for terminal
    input too. Makes re-definable with `int!`{.interpreted-text
    role="command"}. Thanks to Erich for his longanimity on this and the
    prompt defers.
-   core(MSP430): Use the hardware multiplier if available. Add
    `n>r`{.interpreted-text role="command"} and `nr>`{.interpreted-text
    role="command"}.
-   lib(ALL): Chains: Lists of execution tokens.
-   core(ALL): The three prompt words are now system USER based defers:
    `.ready`{.interpreted-text role="command"} for the \>,
    `.error`{.interpreted-text role="command"} if an error occured and
    `.ok`{.interpreted-text role="command"} if everything was fine. See
    `prompts`{.interpreted-text role="ref"} for more.

4.7.2016: release 6.2
---------------------

-   core+lib(MSP430): New optional assembly (compile-time) words
    `d2*`{.interpreted-text role="command"} and `d2/`{.interpreted-text
    role="command"}.
-   core(ALL): renamed
    `find-name ( addr len -- xt +/-1 | 0)`{.interpreted-text
    role="command"} to `find-xt`{.interpreted-text role="command"},
    compare to `find-name ( addr len --  nt|0)`{.interpreted-text
    role="command"} to deal with name tokens.
-   core(MSP430): add `pause`{.interpreted-text role="command"} to the
    usart IO words.
-   core(ALL): complete recognizer [Rev. 3](/pr/Recognizer-rfc-C.pdf)
    adaption.

17.10.2015: release 6.1
-----------------------

-   core(ALL): Adapt `postpone`{.interpreted-text role="command"} action
    of the recognizers to comply with [Rev.
    3](/pr/Recognizer-rfc-C.pdf). Change your recognizers accordingly.
-   core(MSP430): New devices MSP430 F5529 (Flash) and FR5969 (FRAM).
    See `TI_Launchpad_430`{.interpreted-text role="ref"}.
-   core(MSP430): Extended VM Register A. See
    `Extended-VM`{.interpreted-text role="ref"}
-   lib(ALL): Fix regressions in `Rdefer`{.interpreted-text
    role="command"} and `does>`{.interpreted-text role="command"}. Make
    quotations more robust in corner cases.

6.9.2015: release 6.0
---------------------

-   core(ALL): Fix a few regressions like the TAB handling in
    `accept`{.interpreted-text role="command"}.
-   core(AVR8): Fix `forth-wordlist`{.interpreted-text role="command"}
    to return a valid wordlist id.
-   core(MSP430): many small changes to bring it closer to the AVR8.
    Still fits into 8KB flash.
    -   global variables like `DP`{.interpreted-text role="command"}
        (`HERE`{.interpreted-text role="command"}),
        `STATE`{.interpreted-text role="command"},
        `HLD`{.interpreted-text role="command"} etc instead of USER
        variables-
    -   Same USER area layout. Including deferred words for terminal IO.
    -   complete wordlist support including search order and current.
    -   Emulate AVR EEPROM configuration with a info flash segment.
        Needs `save`{.interpreted-text role="command"} to store the data
        permantly.
    -   Lots of common code, optimized versions of standard words if
        applicable.
    -   preparing for more MSP430 device types.

9.7.2015: release 5.9
---------------------

-   lib: `for`{.interpreted-text role="command"} and
    `next`{.interpreted-text role="command"}. The `i`{.interpreted-text
    role="command"} and `j`{.interpreted-text role="command"} can be
    used as well.
-   core(AVR8): clear all RAM at `cold`{.interpreted-text
    role="command"}.
-   core(MSP430): `DEFER`{.interpreted-text role="command"} and
    `VALUE`{.interpreted-text role="command"} were missing in release
    5.8. `pause`{.interpreted-text role="command"} and
    `turnkey`{.interpreted-text role="command"} using them (RAM based,
    save-able to info flash).
-   core(All): `'`{.interpreted-text role="command"} uses the recognizer
    stack.
-   core(ALL): Fix regression in `literal`{.interpreted-text
    role="command"} (broke e.g. quotations)

25.3.2015: release 5.8
----------------------

-   core(MSP430): new `:noname`{.interpreted-text role="command"} and
    the `defer`{.interpreted-text role="command"} and
    `value`{.interpreted-text role="command"} groups of commands.
-   core(All): words with the same name do the same (mostly).
-   core(AVR8): introduce `<builds`{.interpreted-text role="command"}.
    Together with `does>`{.interpreted-text role="command"} saves one
    flash erase cycle and makes the source work on the MSP430 as well.

1.2.2015: release 5.7
---------------------

-   core(ALL): `name>interpret`{.interpreted-text role="command"} and
    `name>compile`{.interpreted-text role="command"} added. New
    Recognizer `rec:name`{.interpreted-text role="command"} able to
    replace `rec:word`{.interpreted-text role="command"}. Uses name
    tokens (Forth 2012) instead of execution tokens.
-   core(ALL): Lots of bugfixes and regressions. The AVR port should be
    fully usable again.
-   core(MSP430): restructure of the init process:
    `cold`{.interpreted-text role="command"} now transfers the data from
    INFO flash back to RAM if BASE is set and `SAVE`{.interpreted-text
    role="command"} was executed. That way the user code now correctly
    survives a restart. `SAVE`{.interpreted-text role="command"} is much
    like marker that overwrites the previous state and gets no name.

22.12.2014: release 5.6
-----------------------

-   core(AVR): `icompare`{.interpreted-text role="command"} got the same
    return flag semantics as `compare`{.interpreted-text
    role="command"}. The `leave`{.interpreted-text role="command"} and
    `?do`{.interpreted-text role="command"} forward branches are now
    resolved at compile time, saves one cell per loop on the return
    stack at runtime.
-   core(AVR): interrupt vectors are moved from RAM to EEPROM. Saves RAM
    space and simplifies turnkey actions (remove any
    `int!`{.interpreted-text role="command"} from your turnkey!)
-   core: re-arranged source files: controller specific and common code.
-   New architecture: MSP430 (G2553) as used in the
    `TI_LaunchPad_430`{.interpreted-text role="ref"} with code from
    [Camelforth](http://www.camelforth.com) and
    [4€4th](http://www.somersetweb.com/4E4th/EN.html).
-   core: generalized existing `Stacks`{.interpreted-text role="ref"} in
    EEPROM into `map-stack`{.interpreted-text role="command"},
    `get-stack`{.interpreted-text role="command"} and
    `set-stack`{.interpreted-text role="command"}. Used for the search
    order and recognizer stacks.
-   all: changed license to GPLv3.

6.10.2014: release 5.5
----------------------

-   core: Bugfix in `warm`{.interpreted-text role="command"} to
    initialize the interpreter for `turnkey`{.interpreted-text
    role="command"}. Thanks to David.
-   core: bugfixes for handling some negative numbers in
    `+loop`{.interpreted-text role="command"} and `*/`{.interpreted-text
    role="command"}.
-   core: simplified assembly primitves for counted loops. They are now
    faster except for `i`{.interpreted-text role="command"}. The return
    stack gets different numbers now.
-   core: rewrite of `accept`{.interpreted-text role="command"}. The
    user visible change is that the final CR/LF is no longer sent here.
    The forth text interpreter does it elsewhere thus the user interface
    is unchanged.
-   core: Fixed a regression introduced after 5.1: a\<b is not always
    the same as a-b\<0.

16.8.2014: release 5.4
----------------------

-   lib: Almost complete `Blocks`{.interpreted-text role="ref"} wordset
    support. Only a few dark corners behave differently.
-   lib: renamed TWI to I2C, added many tools for it
    `I2C Values`{.interpreted-text role="ref"},
    `I2C EEPROM Blocks`{.interpreted-text role="ref"} and a few more.
-   recipes: [Test Driven
    Development](http://en.wikipedia.org/wiki/Test-driven_development)
    with `Amforth <Testing>`{.interpreted-text role="ref"},
    `Conditional Interpret`{.interpreted-text role="ref"}
-   lib: Fully support the ANS94 String wordset.
-   core: Double cell return stack access words (`2>r`{.interpreted-text
    role="command"} and `2r>`{.interpreted-text role="command"}) missed
    the internal swap\'s. Added new `2r@`{.interpreted-text
    role="command"}.
-   lib: Limited LOCALs

7.5.2013: release 5.3
---------------------

-   core: 2nd generation of `Recognizers`{.interpreted-text role="ref"}
    and their use for native
    `String literals <Recognizer>`{.interpreted-text role="ref"}.
-   core: renamed `edp`{.interpreted-text role="command"} to
    `ehere`{.interpreted-text role="command"}. `here`{.interpreted-text
    role="command"} points to data space, `ehere`{.interpreted-text
    role="command"} points to eeprom data space.
-   core: merged code for defer\'s and value\'s. Speed improvements for
    defer actions.
-   community: MMC/SD-Card from Lubos (So Sorry for beeing late) and
    TCP/IP (`Telnet`{.interpreted-text role="ref"}). Many Thanks to
    Jens. Speed optimized words for SPI in amforth core.
-   doc: [Japanese Getting
    Started](http://amforth-installation-ja.readthedocs.org/ja/latest/index.html)
-   doc: new recipes: `Forward`{.interpreted-text role="ref"},
    `Extended-VM`{.interpreted-text role="ref"},
    `Quotations`{.interpreted-text role="ref"},
    `Exceptions`{.interpreted-text role="ref"},
    `Coroutines`{.interpreted-text role="ref"}, updated recipes:
    `SPI`{.interpreted-text role="ref"},
    `Ardiuno Helloworld`{.interpreted-text role="ref"}

23.12.2013: release 5.2
-----------------------

-   Improved and extended `Values`{.interpreted-text role="ref"}
-   Forth 2012
    [Traverse-Wordlist](http://www.forth200x.org/traverse-wordlist.html)
-   improved documentation
-   core: added `d0=`{.interpreted-text role="command"} and
    `0=`{.interpreted-text role="command"} as assembly primitives and
    use them in other compare operations. Saves a lot of code space.
-   Wordlist entries are now 8bit clean. Words with umlauts or e.g.
    Greek commands work as expected, unless the terminal does not
    cooperate. Thanks to Enoch.

``` {.forth}
> : Σ  0 swap 0  do  +  loop  ;
 ok
> 7 8 9 3 Σ .
 24  ok
>
```

5.4.2013: release 5.1
---------------------

-   core: Automatic scoping of words. A system hook can be used to use a
    different wordlist than CURRENT to place a new word in. Thanks to
    Enoch for the idea and the code.
-   lib: very flexible CRC8 checksum generator and checker. Thanks to
    Enoch.
-   recipes: `Interrupt Critical Section`{.interpreted-text role="ref"},
    `Unbreakable`{.interpreted-text role="ref"},
    `Efficient Bitmanipulation`{.interpreted-text role="ref"},
    `Dump Utilities`{.interpreted-text role="ref"},
    `Ctrl-C`{.interpreted-text role="ref"} Thanks to Enoch and the
    others on the mailling list for code and inspiration.
-   core: `-int`{.interpreted-text role="command"} does no longer leave
    the SREG register. It only turns off the global interrupt flag.
    Thanks to Enoch.
-   lib: major 1-wire enhancements: CRC checks and a better naming
    convention for all words. Thanks to Erich for help and substantial
    contributions.
-   appl: added the Arduino Leonardo. avrdude needs a small patch to
    write properly the eeprom on the Atmega32U4.
-   core: New `popcnt`{.interpreted-text role="command"} (n \-- m)
    counts the [Hamming
    Weight](http://en.wikipedia.org/wiki/Hamming_weight) of the given
    number.
-   core: renamed `baud`{.interpreted-text role="command"} to
    `ubrr`{.interpreted-text role="command"}.
-   core: `nfa>lfa`{.interpreted-text role="command"} is a factor in a
    number of words. It generates the link field address from a given
    name field address.
-   doc: Farewell docbook XML, welcome reST. All documentation will be
    written in [reStructured Text](http://sphinx-doc.org/).
-   lib: Simple Quotations. Their typical use case is

``` {.forth}
: foo ... [: bar baz ;] ... ;
```

which is equivalent to

``` {.forth}
:noname bar baz ; Constant#temp#
: foo ... #temp# ...;
```

27.12.2012: release 5.0
-----------------------

-   lib: Access to `1-Wire`{.interpreted-text role="ref"}. Based on code
    and ideas by Bradford J. Rodriguez for the [4€4th
    project](http://www.4e4th.eu).
-   lib: many Arduino ports have more than one purpose. The forth200x
    [Synonym](http://www.forth200x.org/synonym.html) gives them useful
    alias names.\</a\>
-   Arduino: Added definitions for all ports based upon
    `Digital Ports`{.interpreted-text role="ref"}.
-   recipes: There are now more than 30 `Cookbook`{.interpreted-text
    role="ref"} in the cookbook: many debug tools, loop with timeout,
    porting from C, and interrupts to mention some of them.
-   core: autogenerate `sleep`{.interpreted-text role="command"}
    depending on register availability. `sleep`{.interpreted-text
    role="command"} on an Atmega32 is very different from an Atmega328p.
    The parameters for calling it at the forth level are the same
    however. The include list for the assembler is expanded with
    `core/<device>/`{.interpreted-text role="file"} to find the right
    `sleep.asm`{.interpreted-text role="file"} file.
-   core: rudimentary error checks in the compiler: There has to be
    branch destination on the stack. If there is nothing, a stack
    underflow exception gets thrown.

``` {.forth}
> : ?do i . loop ;
?? -4 14
> : t2 ?do i . loop ;
 ok
>
```

-   core: Number sign may follow the number base prefix as specified in
    [Forth200x Number
    Prefix](http://www.forth200x.org/number-prefixes.html). Added the
    character \# as prefix for decimal as well.
-   core: fixed a regression in `toupper`{.interpreted-text
    role="command"} caused by making `within`{.interpreted-text
    role="command"} standards compliant. Thanks to Arthur for the fix.
    `[compile]`{.interpreted-text role="command"} fixed as well.

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
    Updated the `Upload`{.interpreted-text role="ref"} for this task
-   lib: re-arranged source files, improved timer modules.
-   lib: `case`{.interpreted-text role="command"} did not work at all.
    Thanks to Jan for telling.
-   core: the new variable `latest`{.interpreted-text role="command"}
    has the XT of the currently being defined colon word.
-   core: `unused`{.interpreted-text role="command"} should tell the
    free amount of memory in the area `here`{.interpreted-text
    role="command"} points to: RAM. Thanks to Carsten for the hint.
-   core: introducing an environment query for basic controller
    information: memory sizes, max dictionary address:
    `mcu-info`{.interpreted-text role="command"}. The structure itself
    is not yet finalized. See at the end of a
    [core/\<device\>/device.asm
    \<http://amforth.svn.sourceforge.net/viewvc/amforth/trunk/core/devices/atmega328/device.asm?view=markup\>]()
    file for details.
-   tools: The upload utilities were unable to process absolute
    filenames (those beginning with a /) Thanks to Carsten for the fix.

26.3.2012: release 4.8
----------------------

-   core: fixed a bug in `na@`{.interpreted-text role="command"} and
    `nb@`{.interpreted-text role="command"} (extended VM registers).
-   core: redesigned `to`{.interpreted-text role="command"} for use in
    LOCALs and RAM-based values.
-   core: `.s`{.interpreted-text role="command"} is stripped down to a
    single line output of the stack content only. Looks better in the
    call tracer and is more like other forth\'s.
-   core: small atxmega updates. Unfortunatly avrdude cannot flash the
    boot loader section as expected.
-   core: optional Unified memory address space. `@`{.interpreted-text
    role="command"} and `!`{.interpreted-text role="command"} use the
    range from 0 to RAMEND as RAM, from RAMEND+1 upwards the next
    addresses from EEPROM, until EEPROMEND is reached and the remaining
    addresses from flash.
-   core: `environment?`{.interpreted-text role="command"} can now be
    used in colon definitions. changed into loadable forth source
    instead of compile-time assembly.
-   core: `itype`{.interpreted-text role="command"} now sends proper
    (e.g. single byte) characters to `emit`{.interpreted-text
    role="command"}.
-   core: `type`{.interpreted-text role="command"} is made more robust
    against `emit`{.interpreted-text role="command"} errors.
-   lib: `macro`{.interpreted-text role="command"} and a
    `Defining and using Macros`{.interpreted-text role="ref"} recipe for
    using them.
-   `Profiler`{.interpreted-text role="ref"} to count the number of
    calls.
-   lib: `evaluate`{.interpreted-text role="command"} for both RAM and
    Flash based strings.

4.2.2012: release 4.7
---------------------

-   recipes: `Multitasking`{.interpreted-text role="ref"},
    `Reason For Reset`{.interpreted-text role="ref"} and
    `Tracer`{.interpreted-text role="ref"}
-   core: new words from the STRINGS word set:
    `sliteral`{.interpreted-text role="command"} and
    `compare`{.interpreted-text role="command"}. Latter is a simplified
    version of the ANS94 spec: max 255 chars, (in)equality tests only.
-   core: `source`{.interpreted-text role="command"},
    `refill`{.interpreted-text role="command"} are now deferred words,
    based on the USER area. `>in`{.interpreted-text role="command"}
    likewise. Based on ideas from [Strong
    Forth](http://home.vrweb.de/stephan.becher/forth/doc/chapter11.htm).
-   core: `/key`{.interpreted-text role="command"} removed, it can be
    implemented by changing `refill`{.interpreted-text role="command"}.
-   lib: The multitasker could not work after power cycles. Thanks to
    Erich for fixing.

6.10.2011: release 4.6
----------------------

-   core: `words`{.interpreted-text role="command"} shows the *first*
    entry in the search order list as specified by DPANS94.
-   lib: new word `m*/`{.interpreted-text role="command"} (d1 n1 n2 \--
    d2), uses a triple cell intermediate for d1\*n1.
-   lib: new words `bm-set`{.interpreted-text role="command"},
    `bm-clear`{.interpreted-text role="command"} and
    `bm-toggle`{.interpreted-text role="command"} that efficiently
    change bits in RAM byte addresses. e.g.
    ` %0010 here bm-toggle`{.interpreted-text role="command"} changes
    bit 2 in the RAM location at `here`{.interpreted-text
    role="command"}.
-   lib: renamed `spirw`{.interpreted-text role="command"} to
    `c!@spi`{.interpreted-text role="command"}, new word
    `!@spi`{.interpreted-text role="command"} exchanges two bytes via
    SPI. Follows remotly the memory access word naming conventions.

29.6.2011: release 4.5
----------------------

-   arduino: re-arranged word placing to maximize usable flash (at least
    on a duemilanove device, the bigger variants like the sanguino and
    mega\* still have room for improvement). The target mega is now
    called mega128.
-   lib: `lib/buffer.frt`{.interpreted-text role="file"} implements
    [buffer:](http://www.forth200x.org/buffer.html).
-   doc: improved refcard. Thanks to Erich for input and patches.
-   core: changed API of the [Recognizer](/pr/Recognizer-en.pdf) to the
    final addr/len pairs. Do not use counted strings any longer!
-   core: new words `find-name`{.interpreted-text role="command"} and
    `parse-name`{.interpreted-text role="command"} follow [Forth
    200x](http://www.forth200x.org/parse-name.html) and operate on the
    current input buffer, `word`{.interpreted-text role="command"} is no
    longer used internally. Lots of internal code simplifications.
-   core: `(create)`{.interpreted-text role="command"} throws exception
    -16 if no name is given.
-   core: exception -42 is really -4 (stack underflow).
-   core: `digit?`{.interpreted-text role="command"} again. Stack effect
    now compatible to gforth:
    `( char -- n true | false)`{.interpreted-text role="command"}.
    Current setting of `base`{.interpreted-text role="command"} is now
    taken internally.

24.5.2011: release 4.4
----------------------

-   examples: added a game of life and a queens puzzle solver.
-   core: restructure of the RAM usage. You need to remove the
    `.set here = ...`{.interpreted-text role="command"} line from your
    application definition file (template.asm).
-   core: turn `cold`{.interpreted-text role="command"} into the main
    initialization word and `warm`{.interpreted-text role="command"}
    into some high level initialization.
-   doc: updated Technical Documentation of Recognizers and Interrupt
    Processing. Reformatted the `RefCard`{.interpreted-text role="ref"}
    to a more compact style.
-   core: added `n>r`{.interpreted-text role="command"} and
    `nr>`{.interpreted-text role="command"} from [Forth
    200x](http://www.forth200x.org/n-to-r.html).
-   core: Redesign of Interrupt Handling. ISR Routines are still normal
    Colon Words and can deal with every kind of interupts. There are no
    lost interupts any longer. Based on Ideas from Wojciech (Tracker
    ID 2781547) and Al (mailling list).
-   appl: Fixed a regression in the floating point library due to
    changes in `number`{.interpreted-text role="command"} in post 4.0
    releases. `>float`{.interpreted-text role="command"} can now be used
    as the main part of a recognizer.
-   core: added a compile time option WANT\_IGNORECASE to make amforth
    case-insensitve, disabled by default.

1.5.2011: release 4.3
---------------------

-   core: `u>`{.interpreted-text role="command"} had wrong stack effect
    in case of true result.
-   core: `int-trap`{.interpreted-text role="command"} triggers an
    interrupt from software.
-   core: `/user`{.interpreted-text role="command"} environment query
    gives the size of the USER area
-   core: `sleep`{.interpreted-text role="command"} takes the sleep mode
    as parameter.
-   ex: added timer-interrupt.frt as an example for using interrupts
    with forth.
-   pub: Erich has presented amforth at the Fosdem 2011
    [Slides](/pr/Fosdem2011-slides-amforth.pdf) and
    [Proceedings](/pr/Fosdem2011-proceedings-amforth.pdf) (published
    with permission). Thanks Erich!
-   core: simplified `get/set-order`{.interpreted-text role="command"}
    with a changed eeprom content.
-   doc: new user guide version from Karl (for version 4.2).
-   core: renamed `e@/e!`{.interpreted-text role="command"} to
    `@e/!e`{.interpreted-text role="command"} to comply with the memory
    access wordset from forth200x, same with `i@/i!`{.interpreted-text
    role="command"}.
-   core: documentation fixes in many files: `RefCard`{.interpreted-text
    role="ref"}.
-   core: re-design of the (outer) interpreter using recognizers
    (dynamically extend the interpeter to deal with new semantics.
    Defined `get/set-recognizer`{.interpreted-text role="command"}
    similiar to `get/set-order`{.interpreted-text role="command"}.

19.9.2010: release 4.2
----------------------

-   core: fixed a regression for `i!`{.interpreted-text role="command"}
    which made `marker`{.interpreted-text role="command"} useless (among
    other oddities). Thanks to Marcin for the fix
-   core: currently defined colon words are invisible until the final ;.
-   applications: Leon contributed a IEEE754 floating point library in
    plain forth, Pito translated some basic words into assembly for
    speed.

2.9.2010: release 4.1
---------------------

-   core: new words `2>r`{.interpreted-text role="command"},
    `2r>`{.interpreted-text role="command"} and
    `2literal`{.interpreted-text role="command"}.
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
    `HEAP`{.interpreted-text role="command"} is gone. Migrate old HEAP
    to HERE and old HERE to DP.
-   core: save and clear the initial value of the MCU Status Register at
    address 10.
-   tools: pd2amforth is now capable to generate the device definition
    files. It is no longer necessary to edit them manually.
-   core: finally separated the terminal IO settings from the device
    definition files.
-   core: optionally set `WANT_SPI` (or any other IO Module) to include
    the register definion names at build time.
-   core: massivly restructured the `devices/`{.interpreted-text
    role="file"} filesystem entry. Change your application files to
    include `device.asm`{.interpreted-text role="file"} instead of the
    device name. Set the include directory to the proper subdirectory
    under `core/devices`{.interpreted-text role="file"} as well.
-   core: dynamically calculate the free space. Do not use all of it
    however, the data stack may grow.

``` {.forth}
s" /pad" environment?
```

-   core: Simplified the Pictured Numeric Output words. They now use the
    memory area below `pad`{.interpreted-text role="command"} (which is
    100 bytes above HEAP) as the buffer region.
-   appl: added the arduino board with some example codes. Currently
    with the Mega (Atmega1280), Duemilanove (Atmega328) and Sanguino
    (Atmega644p) controller types.

25.5.2010: release 3.9
----------------------

-   web: updated the Howto page to demonstrate
    `Redirect IO`{.interpreted-text role="ref"}.
-   core: The Atmega2561 now fully works (incl the compiler).
-   core, appl: Andy Kirby donated the device files and a full
    implemention for Arduino Mega with the Atmega1280.
-   core: CPU Name, Forthname and Version strings can be accessed as
    environment queries.

25.4.2010: release 3.8
----------------------

-   core: turned `i!`{.interpreted-text role="command"} into a deferred
    word.
-   core: fix for `icompare`{.interpreted-text role="command"} to make
    it work with all addr/len strings. Bug found and fixed by Michael
    and Adolf.
-   core: re-implemented the `i!`{.interpreted-text role="command"} in
    (mostly) assembly language to ease integration into bootloaders.
-   core: factor the three prompts into compile time changable words.
-   appl: the `dict_minimum.inc`{.interpreted-text role="file"} und
    `dict_core.inc`{.interpreted-text role="file"} files need to be
    included within the application defition files.
-   core: `pad`{.interpreted-text role="command"} is no longer used by
    amforth itself.
-   core: reorder internal code in `interpret`{.interpreted-text
    role="command"} to get rid of `0=`{.interpreted-text role="command"}
    calls.

24.1.2010: release 3.7
----------------------

-   core: atxmega 128 support (no compiler yet).
-   core: new word `>number`{.interpreted-text role="command"}.
    `number`{.interpreted-text role="command"} accepts trailing (!) dots
    to enter double cell numbers.
-   lib: enhanced multitasker with turnkey support. Thanks to Erich
    W&auml;lde for in depth debugging and testing.
-   lib: new word `anew`{.interpreted-text role="command"} drops word
    definitions if already defined, starts a new generation.
-   core: USER area is now split into system and application user areas,
    system user area is pre-set from EEPROM.
-   new: source repository
    [Incubator](http://amforth.svn.sourceforge.net/viewvc/amforth/incubator/)
    for not-yet-ready-but-interesting projects, volunteers welcome.

1.10.2009: release 3.6
----------------------

-   core: new word `environment`{.interpreted-text role="command"}. It
    provides the environment wordlist identifier, thus make it possible
    to create own environment queries as standard words.
-   core: new word `d=`{.interpreted-text role="command"}.
-   core: amforth runs partially on an atmega2561 and atxmega\'s, there
    is still no working flash store word (`i!`{.interpreted-text
    role="command"}) therefore only the interpreter is available yet.
-   core: moved the usart init values to appl section.
-   core: added a poll-only receive word, selectable at compile time.
    Disable the rx interrupt to use it.

1.9.2009: release 3.5
---------------------

-   core: re-structure the usart code, added a non-interrupt based
    transmit word (TX), selectable at compile time.
-   lib: added `xt>nfa`{.interpreted-text role="command"} that goes from
    the XT to the name field address.
-   core: bugfix `recurse`{.interpreted-text role="command"}.
-   core: restructured EEPROM, never depend on fixed addresses for
    system values.
-   core: added a `dict_wl.inc`{.interpreted-text role="file"} file with
    most of the non-core wordlist commands.

11.4.2009: release 3.4
----------------------

-   core: renamed the words for the serial terminal to be more generic
    since they can deal with any serial port, not only the first one.
-   lib: dropped `forget`{.interpreted-text role="command"} since it
    cannot work with multiple wordlists, fixed
    `marker`{.interpreted-text role="command"}.
-   core: changed again `digit?`{.interpreted-text role="command"} stack
    effect (and fixed a little bug).
-   core: `number`{.interpreted-text role="command"} honors a leading &,
    \$ or % sign to temporarily switch to DECIMAL, HEX or BIN base resp.
    Thanks to Michael Kalus for factoring the code.

22.2.2009: release 3.3
----------------------

-   core: faster `noop`{.interpreted-text role="command"}.
-   added ANS94 search order wordlist.
-   core: `within`{.interpreted-text role="command"} had problems with
    signed boundaries, literal numbers are processed faster (again).
-   core: improved `digit?`{.interpreted-text role="command"} and
    `number`{.interpreted-text role="command"}. They now report errors
    on invalid characters at the wrong position. The following strings
    are no longer valid numbers: \--1 or 0@ (in base hex).
-   core: `-1 spaces`{.interpreted-text role="command"} now prints
    nothing, Fix from Lothar Schmidt.
-   core: `(loop)`{.interpreted-text role="command"} (runtime of loop)
    now checks for equality only, as specified in ANS94.

10.1.2009: release 3.2
----------------------

-   core: bugfix for trailling 0x00 byte during
    `itype`{.interpreted-text role="command"}.
-   core: enable use of other usart port than 0.
-   pc-host: [Ken
    Staton](http://staton.us/electronics/remote_IO/atmega_bit_whacker.html)
    wrote a nice pc based terminal with upload functionality.
-   core: New controllers: ATmega328P and ATmega640.
-   core: changed `digit`{.interpreted-text role="command"} to
    `digit?`{.interpreted-text role="command"} found in many other
    forth\'s.
-   core: new word `within`{.interpreted-text role="command"}.
-   core: split application dictionary definition into 2 parts, one for
    the lower flash, one for the upper (NRWW) flash. Both can be empty,
    but need to exists.
-   core: changed some names for internal constants (baudrate -\> BAUD)
    and registers (EEPE vs EEWE).
-   core: new directory `drivers/`{.interpreted-text role="file"} for
    low level driver functions. Currently only the generic ISR and the
    USART0 interrupt handler.

10.11.2008: release 3.1
-----------------------

-   core: `icompare`{.interpreted-text role="command"} now has a
    similiar stack effect as `compare`{.interpreted-text
    role="command"}.
-   core: new word: `environment?`{.interpreted-text role="command"}.
    Supports `/hold`{.interpreted-text role="command"} query.
-   core: Strings in flash (incl. names in the dictionary) contain now
    16bit length information, previously only 8 bit.

17.10.2008: release 3.0
-----------------------

-   core: `s"`{.interpreted-text role="command"} new with interpreter
    semantics.

``` {.forth}
s" hello world" type`
```

works at the command prompt. The compiled version is

``` {.forth}
: hw s" hello world" itype ;
```

-   core: Placement of Stacks is now an application setting. See example
    apps.
-   core: added VM register A and B. See [Stephen Pelc\'
    Slides](http://www.complang.tuwien.ac.at/anton/euroforth/ef08/papers/pelc.pdf)
    for details. Uses Atmega Register R6:R7, R8:R9 resp.
-   core: added `cmove`{.interpreted-text role="command"} as a primitve.
-   core: `f_cpu`{.interpreted-text role="command"} used the old
    (pre-2.7) stack order for double cell values.
-   lib: moved some definitions to more appropriate files.

1.8.2008: release 2.9
---------------------

-   core: `heap`{.interpreted-text role="command"},
    `here`{.interpreted-text role="command"} and `edp`{.interpreted-text
    role="command"} are now VALUEs. `dp`{.interpreted-text
    role="command"} is gone (use `here`{.interpreted-text
    role="command"})
-   lib: more VT100 sequences.
-   core: The TIB location and size are accessible with the VALUEs
    `TIB`{.interpreted-text role="command"} and
    `TIBSIZE`{.interpreted-text role="command"}.
-   core: fixed TIBSIZE default configuration.
-   lib: created math.frt, contains among others the standard words
    `sm/rem`{.interpreted-text role="command"},
    `fm/mod`{.interpreted-text role="command"}.
-   Alexander Guy fixed a bug in `u*/mod`{.interpreted-text
    role="command"}.
-   Bernard Mentink adapted Julian Noble\'s Finite State Machine code.
-   applications: Lubos Pekny designed a smart computer with a 4line
    character LCD and a PS/2 keyboard. Details are in the [Application
    Repository](http://amforth.svn.sourceforge.net/viewvc/amforth/applications),
    a video is
    [available](http://www.forth.cz/Download/App/LCD+KbdPS2.avi) as
    well.

27.6.2008: release 2.8
----------------------

-   core: Lubos Pekny found that `-jtag`{.interpreted-text
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
-   core: `m*`{.interpreted-text role="command"} was in fact
    `um*`{.interpreted-text role="command"}.
-   core: double cell numbers changed stack order: TOS is now the most
    significant cell.
-   library: new: assembler written by Lubos Pekny,
    [www.forth.cz](http://www.forth.cz). Thank you!
-   examples: PWM example from Bruce Wolk. TWI/I2C EEPROM access

27.1.2008: release 2.6
----------------------

-   core: new defining words `code`{.interpreted-text role="command"}
    and `end-code`{.interpreted-text role="command"}.
    `code`{.interpreted-text role="command"} starts a new dictionary
    header with the XT set to the data field. The 2nd one appends the
    `jmp NEXT`{.interpreted-text role="command"} call into the
    dictionary.
-   core: removed the pre-assembled `case`{.interpreted-text
    role="command"} / `endcase`{.interpreted-text role="command"} words.
    Added them as forth library.
-   core: new words `-jtag`{.interpreted-text role="command"} (turns off
    JTAG at runtime) and `-wdt`{.interpreted-text role="command"} (turns
    off watch dog timer at runtime. They need to be implemented as
    primitives due to timing requirements.
-   core: `quit`{.interpreted-text role="command"}: Keep
    `base`{.interpreted-text role="command"} when handling an exception.
-   library: TWI/I2C EEPROM Support.

6.12.2007: release 2.5
----------------------

-   Bug: `hex 8000 .`{.interpreted-text role="command"} froze the
    controller. Now it prints -8000. Thanks to Lubos for the hint.
-   Moved init of `base`{.interpreted-text role="command"} from
    `quit`{.interpreted-text role="command"} to `cold`{.interpreted-text
    role="command"}. `turnkey`{.interpreted-text role="command"} be used
    to change it permanently. Thanks to Lubos for the hint.
-   nice looking dumper words for RAM/EEPROM/FLASH, dropped idump.asm.
-   Extended Upload utility (`tools/amforth-upload.py`{.interpreted-text
    role="file"}) from piix: include files using following syntax:

``` {.none}
\ demo file
#include ans94/marker.frt
marker empty
```

-   usart transmit (`tx0`{.interpreted-text role="command"}) made more
    robust.
-   User Area restructured for the new multitasker.
-   added documentation: Karl\'s `User Guide`{.interpreted-text
    role="ref"} and a `Technical Guide`{.interpreted-text role="ref"}.

11.10.2007: release 2.4
-----------------------

-   Added AT90CAN128. Other Atmega128 style controllers should work too.
-   lot of fine tuning.
-   dropped the assembler device init portion.
-   New file: `dict_compiler.inc`{.interpreted-text role="file"}.
    Without these words the forth system is (more or less) a pure
    interactive system without extensibility.
-   new words `[char]`{.interpreted-text role="command"},
    `fill`{.interpreted-text role="command"}.
-   re-arranged usart code. fixed bug when usart baud rate calculation
    leads to values greater 255.
-   renamed `/int`{.interpreted-text role="command"} to
    `-int`{.interpreted-text role="command"} and `int`{.interpreted-text
    role="command"} to `+int`{.interpreted-text role="command"}, it\'s
    more fortish ;=)

29.7.2007: release 2.3
----------------------

-   new words `spaces`{.interpreted-text role="command"} and
    `place`{.interpreted-text role="command"}.
-   Improved `i!`{.interpreted-text role="command"}.
-   bugfixing runtime parts of `do`{.interpreted-text
    role="command"}/`loop`{.interpreted-text role="command"} and co.
-   re-coded `find`{.interpreted-text role="command"} and
    `icompare`{.interpreted-text role="command"} for better readability.
-   eliminated code duplets in some primitives.
-   moved usart init from `cold`{.interpreted-text role="command"} to
    application specific turn key action. Added error checking in
    receive module.

17.6.2007: release 2.2
----------------------

-   new download section: application
-   optional dictionary is now part of the application, therefore
    renamed to dict\_appl.
-   new words: `leave`{.interpreted-text role="command"} and
    `?do`{.interpreted-text role="command"}.

22.5.2007 release 2.1
---------------------

-   changed stack effect for `#`{.interpreted-text role="command"} to
    ansi (from single cell value to double cell). Double cell values do
    not work (yet).
-   introduced `deferred`{.interpreted-text role="command"} words
    instead of tick-variables. Works for EEPROM based vectors (turnkey),
    RAM based (`pause`{.interpreted-text role="command"}) and User based
    (`emit`{.interpreted-text role="command"} etc) vectors.
-   new words: `wdr`{.interpreted-text role="command"} (Watchdog reset),
    `d>`{.interpreted-text role="command"} and `d<`{.interpreted-text
    role="command"} (double cell compare).

2.5.2007 release 2.0
--------------------

-   internal restructure of targets.
-   new words: `u>`{.interpreted-text role="command"} and
    `u<`{.interpreted-text role="command"}.
-   bugfixing interrupts.
-   new word: `log2`{.interpreted-text role="command"} logarithm to base
    2, or the number of the highest 1 bit.
-   fixed wrong addresses for usart-io (esp. butterfly)

25.4.2007 release 1.9
---------------------

-   renamed `dict_low.asm`{.interpreted-text role="file"} to
    `dict_minimal.asm`{.interpreted-text role="file"}.
-   new word `parse`{.interpreted-text role="command"} ( c \-- addr len)
    parses `source`{.interpreted-text role="command"} for char delimited
    strings.
-   new word `sleep`{.interpreted-text role="command"} ( \-- ) puts the
    controller into (previously defined) sleep mode.
-   new words `s"`{.interpreted-text role="command"} ( \-- addr len)
    parses TIB for \" character and compiles it into flash,
    `s,`{.interpreted-text role="command"} ( addr len \-- ) does the
    real copying of the string into flash at `here`{.interpreted-text
    role="command"} together with the invisible word
    `(sliteral)`{.interpreted-text role="command"} (\-- flash-addr len).
-   bugfix: `f_cpu`{.interpreted-text role="command"} had wrong word
    order. Use `swap`{.interpreted-text role="command"} as a temporary
    work around.\`
-   re-wrote initialisation of usart0 ( baud \-- ) to forth code.
    Startup speed is taken from (eeprom) VALUE `baud0`{.interpreted-text
    role="command"}.

10.4.2007 release 1.8
---------------------

-   interrupt handling redesigned. Now every interrupt (except those for
    usart0) can be used. `intcounter`{.interpreted-text role="command"}
    is gone. New words are `int@`{.interpreted-text role="command"},
    `int!`{.interpreted-text role="command"} and
    `#int`{.interpreted-text role="command"}.
-   double and mixed cell arithmetics.\`
-   bugfix: proper initialization of data stack pointer. Thanks to
    Maciej Witkowiak.
-   move TOS into register pair.

3.4.2007 release 1.7
--------------------

-   new word: `f_cpu`{.interpreted-text role="command"} sets a double
    cell value with the cpu clock rate.
-   `hld`{.interpreted-text role="command"} is now at
    `pad`{.interpreted-text role="command"} to save RAM.
-   `pad`{.interpreted-text role="command"} did return some compile-time
    stochastic value\`
-   lots of internal changes.
-   optional dictionary: `d-`{.interpreted-text role="command"},
    `d+`{.interpreted-text role="command"}, `s>d`{.interpreted-text
    role="command"} and `d>s`{.interpreted-text role="command"}.

25.3.2007 release 1.6
---------------------

-   split `blocks/ans.frt`{.interpreted-text role="file"} into pieces.
-   `sign`{.interpreted-text role="command"} no longer inserts a space
    for non-negative values.
-   new word: `/key`{.interpreted-text role="command"}. It is vectorized
    via `'/key`{.interpreted-text role="command"} and gets called by
    `accept`{.interpreted-text role="command"} to signal the sender to
    stop transmission. See `blocks/xonxoff.frt`{.interpreted-text
    role="file"} for example usage.
-   replaces `up`{.interpreted-text role="command"} with
    `up@`{.interpreted-text role="command"} and `up!`{.interpreted-text
    role="command"}.
-   new word: `j`{.interpreted-text role="command"} ( \-- n).
-   new word: `?execute`{.interpreted-text role="command"} ( xt\|0 \-- )
    if non-zero execute the XT.
-   The Atmega644 works fine :=) but needs the Atmel assembler (see
    `FAQ`{.interpreted-text role="ref"}) :=(
-   Bugfix: `+!`{.interpreted-text role="command"} did a
    `+`{.interpreted-text role="command"} only.
-   Bugfix: too many spaces in `.`{.interpreted-text role="command"}
    (dot).
-   give user variables `rp`{.interpreted-text role="command"} and
    `sp`{.interpreted-text role="command"} a name.

14.3.2007 release 1.5
---------------------

-   changed: `itype`{.interpreted-text role="command"} and (new)
    `icount`{.interpreted-text role="command"} refactored by Michael
    Kalus. These words now have similiar stack effects as there RAM
    counterparts.
-   changed: `.`{.interpreted-text role="command"} now operates on
    signed values.
-   new word: `u/mod`{.interpreted-text role="command"} is basically the
    former `/mod`{.interpreted-text role="command"}.
-   new word: `u.`{.interpreted-text role="command"} to display unsigned
    values.
-   fixed bug in `/mod`{.interpreted-text role="command"} for values
    less -FF (hex).
-   `create`{.interpreted-text role="command"} left the address of the
    XT insted of the PFA. Fixed.
-   deleted word: `idump`{.interpreted-text role="command"}. It is now
    in the file `blocks/misc.frt`{.interpreted-text role="file"}.
-   new word: `:noname`{.interpreted-text role="command"} ( \-- xt)
    creates headerless entry in the dictionary.
-   new word: `cold`{.interpreted-text role="command"} as main entry
    point. It executes the turnkey action. `abort`{.interpreted-text
    role="command"} & co do not trigger the turnkey action.

5.3.2007 release 1.4
--------------------

-   `pad`{.interpreted-text role="command"} is now in the unsed
    (according to `heap`{.interpreted-text role="command"}) ram. That
    may help `word`{.interpreted-text role="command"} to store longer
    strings.
-   new word: `unused`{.interpreted-text role="command"} ( \-- n) gives
    the number of unused flash cells in the dictionary.
-   `/mod`{.interpreted-text role="command"} (and `/`{.interpreted-text
    role="command"} and `mod`{.interpreted-text role="command"}) now
    honor signed numbers, division is symmetric.
-   new word: `abort"`{.interpreted-text role="command"}
-   `quit`{.interpreted-text role="command"} now aborts on every catched
    exception.
-   `quit`{.interpreted-text role="command"} no longer prints anything,
    `ver`{.interpreted-text role="command"} is now a turnkey action.
-   new optional dictionary, included at compiletime. Contains now
    `case`{.interpreted-text role="command"} &amp; Co and some
    `d-`{.interpreted-text role="command"} words for double cell
    arithmetics.

24.2.2007 release 1.3
---------------------

-   bug: `digit`{.interpreted-text role="command"} did not work properly
-   bug: `<`{.interpreted-text role="command"}: equal is not less
-   interrupts are processed faster
-   Interrupt counter are now only 1 byte long (access with
    `c@`{.interpreted-text role="command"})
-   change: `allot`{.interpreted-text role="command"} works now for ram
    not for flash
-   added/corrected stack comments
-   bug: `create`{.interpreted-text role="command"} leaves flash address
    insted of first cell content
-   change: `.s`{.interpreted-text role="command"} nicer for empty stack
-   internal: `i!`{.interpreted-text role="command"} internally
    completly turns off interrupts
-   bug: `abort`{.interpreted-text role="command"} now works again,
    error was in `quit`{.interpreted-text role="command"}
-   bug: `while`{.interpreted-text role="command"} and
    `repeat`{.interpreted-text role="command"} changed stack effects
-   bug: `r@`{.interpreted-text role="command"} now works correctly
-   new word: `immediate`{.interpreted-text role="command"}
-   removed words: `forget`{.interpreted-text role="command"},
    `postpone`{.interpreted-text role="command"} (these and many more
    are now in the `blocks/ans.frt`{.interpreted-text role="command"}
    library)
-   bug: if `'`{.interpreted-text role="command"} (tick) does not find
    the word, it now throws the exception -13 Many thanks to Ulrich
    Hoffmann for providing feedback and corrections!

3.2.2007 release 1.2
--------------------

-   anyone missed `emit?`{.interpreted-text role="command"}?.
-   increased user area to 24 bytes (12 cells). Fixed a overlap between
    `handler`{.interpreted-text role="command"} and
    `emit`{.interpreted-text role="command"} ff.
-   AVR `AVR Butterfly`{.interpreted-text role="ref"} works (again).
    Many thanks to the [German FIG](http://www.forth-ev.de/) for
    donating one.
-   internal changes for multitarget development (for the AREXX asuro
    minirobot).

20.1.2007 release 1.1
---------------------

-   `emit`{.interpreted-text role="command"}, `key`{.interpreted-text
    role="command"} and `key?`{.interpreted-text role="command"} are now
    vectored via `user`{.interpreted-text role="command"} based
    variables.
-   `forget`{.interpreted-text role="command"} frees most of the flash
    space too
-   internal go back for `i!`{.interpreted-text role="command"} to
    previous code
-   Code for Atmega8 was broken due to nrww flash overflow (found by
    Milan Horkel)
-   Bugfix: backspace key in `accept`{.interpreted-text role="command"}
    now stops at beginning of line (found by Milan Horkel)

4.1.2007 release 1.0
--------------------

-   new immediate word: `[']`{.interpreted-text role="command"}
-   new word `user`{.interpreted-text role="command"} defines user
    variables
-   new controller: atmega169 (Atmel Butterfly)
-   renamed `eheap`{.interpreted-text role="command"} to
    `edp`{.interpreted-text role="command"}.

17.12.2006 release 0.9
----------------------

-   interrupts in high level forth colon words (INT0 and INT1 for now).
-   new word: `noop`{.interpreted-text role="command"} a colon word for
    doing nothing.
-   `number`{.interpreted-text role="command"} respects minus sign
-   changed `turnkey`{.interpreted-text role="command"} into
    `'turnkey`{.interpreted-text role="command"}. The
    &quot;turn-off&quot; value is now 0 (zero)
-   new words: `pause`{.interpreted-text role="command"} and
    `'pause`{.interpreted-text role="command"}.
    `pause`{.interpreted-text role="command"} will execute the XT stored
    in `'pause`{.interpreted-text role="command"} (a RAM cell) when non
    zero
-   `handler`{.interpreted-text role="command"} (used by
    `cactch`{.interpreted-text role="command"} and
    `throw`{.interpreted-text role="command"}) is a USER variable.

7.12.2006 release 0.8
---------------------

-   new words: `create`{.interpreted-text role="command"},
    `does>`{.interpreted-text role="command"}, `up`{.interpreted-text
    role="command"}, `0`{.interpreted-text role="command"}
-   Support for user variable, turned `base`{.interpreted-text
    role="command"}, `rp0`{.interpreted-text role="command"} and
    `sp0`{.interpreted-text role="command"} into user variables
-   words like `(do)`{.interpreted-text role="command"} which should not
    by called by user are now invisible to save nrww flash space
-   bugfix for negative increment for `+loop`{.interpreted-text
    role="command"}.

24.11.2006 release 0.7
----------------------

-   new word: `turnkey`{.interpreted-text role="command"}: executed
    whenever `quit`{.interpreted-text role="command"} starts.
-   numbers may contain lower case characters (if
    `base`{.interpreted-text role="command"} permits)
-   bugfixing `case`{.interpreted-text role="command"} & co.
-   `number`{.interpreted-text role="command"} emits -13 if an invalid
    character is found
-   renamed `vheader`{.interpreted-text role="command"} to
    `(create)`{.interpreted-text role="command"}
-   `abort`{.interpreted-text role="command"} re-initializes both stacks
-   made backslash `\\`{.interpreted-text role="command"} immediate

20.11.2006 release 0.6
----------------------

-   backspace now works in `accept`{.interpreted-text role="command"}
-   `depth`{.interpreted-text role="command"} based on
    `sp0`{.interpreted-text role="command"}/`sp@`{.interpreted-text
    role="command"}
-   \"unused\" control characters are treated as spaces
-   bugfixes for `(loop)`{.interpreted-text role="command"} and
    `(+lopp)`{.interpreted-text role="command"}.
-   New words: `1ms`{.interpreted-text role="command"} busy waits 1
    millisecond

13.11.2006 release 0.5
----------------------

-   definition files for varios atmega types
-   core wordlist should be complete
-   internal cleanups and bugfixes

5.11.2006 release 0.4
---------------------

-   start using `catch`{.interpreted-text
    role="command"}/`throw`{.interpreted-text role="command"}
-   Atmega8 works fine
-   few new words (`case`{.interpreted-text role="command"}, comments)
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
