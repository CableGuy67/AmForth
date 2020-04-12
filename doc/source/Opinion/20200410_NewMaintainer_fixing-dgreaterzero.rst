.. _NewMaintainer_fixing-dgreaterzero:


Fixing :command:`D0>`
=====================


So here I am, the new maintainer of AmForth. I will do my very best.


Error Report
............

In August 2019 the mailing list received this simple error report.

::
                  
    From: Martin Nicholas via Amforth-devel
    Subject: [Amforth] Missing DU<
    ...
    Also, a bug in D0>:
    Hmmm, something wrong here I feel:
    
    > (ATmega2560)> decimal  1553994000. d0> .   1572137999. d0> .  
    > -1 0  ok  


At the time I did not have a good idea, on how to handle this, let
alone how to fix any error uncovered. But times are achanging. I
decided to publish my path, attempts, insights, and decisions in the
hope that interested folks can see *it's not rocket science at all*.
And I opted for English text in the hope to reach a larger audience.
All errors in this text are mine, I'm afraid.

Reproducing the Error
.....................

When preparing for the annual (german speaking)
`Forth Tagung 2020 <http://wiki.forth-ev.de/doku.php>`__
(see also `Tagungen <http://wiki.forth-ev.de/doku.php/events:start>`__)
--- which was replaced by a video conference like so many others ---
I started to dig in. A few things were understood quickly:

* There is an assembly version of :command:`d0>`, which exhibits the bug.
* There is a pure Forth version, which works correctly.
* The sign of the lower word was apparently used to derive the
  answer, which seemed odd.

At this point I understood the assembly code only partly.


Adding Test Cases
.................

One way to better understand misbehaviour comes through the addition
of a useful set of test cases. In order to compare the Forth word with
the assembly function, we add the Forth word under a different name:

.. code-block:: forth

    \ file: lib/forth2012/double/d-greater-zero.frt
    \ #require d-less-zero.frt
    : d0< nip 0< ;
    : d0>v1 ( d -- f )
      2dup or >r     \ not equal zero
      d0<  0= r> and \ and not less zero
      0= 0=          \ normalize to 0/-1 flag
    ;
                
There are simpler ways to declare :command:`d0>`, however, we are not
going to change two things at a time, do we? Thanks. Then we include
the Hayes Tester

.. code-block:: forth

    #include lib/forth2012/tester/tester-amforth.frt


The testcases I came up with, since we had already observed that the
sign of the lower word did influence the result, are these:

.. code-block:: forth

    TESTING d0>
    
    t{         0. d0> ->  0 }t
    t{         1. d0> -> -1 }t
    t{     $7FFF. d0> -> -1 }t
    t{     $8000. d0> -> -1 }t
    t{     $8001. d0> -> -1 }t
    t{    $10000. d0> -> -1 }t
    
    t{ $00000000. d0> ->  0 }t
    t{ $00000008. d0> -> -1 }t
    t{ $00000080. d0> -> -1 }t
    t{ $00000800. d0> -> -1 }t
    t{ $00008000. d0> -> -1 }t
    t{ $00080000. d0> -> -1 }t
    t{ $00800000. d0> -> -1 }t
    t{ $08000000. d0> -> -1 }t
    t{ $80000000. d0> ->  0 }t
    
    t{ $80000000. d0> ->  0 }t
    t{ $80000008. d0> ->  0 }t
    t{ $80000080. d0> ->  0 }t
    t{ $80000800. d0> ->  0 }t
    t{ $80008000. d0> ->  0 }t
    t{ $80080000. d0> ->  0 }t
    t{ $80800000. d0> ->  0 }t
    t{ $88000000. d0> ->  0 }t
    
    t{ $FFFFFFFF. d0> ->  0 }t
    t{ $FFFF7FFF. d0> ->  0 }t


These testcases were repeated substituting :command:`d0>` with
:command:`d0>v1` or whatever word was going to be inspected. The
result was as expected: Failed tests wherever the MostSignificantBit
of both halfs of the double word argument were set.

.. code-block:: none

   \ somewhat edited for fewer lines
   > ver
   amforth 6.8 ATmega644P ok
   > TESTING d0>                ok
   > t{         0. d0> ->  0 }t ok
   > t{         1. d0> -> -1 }t ok
   > t{     $7FFF. d0> -> -1 }t ok
   > t{     $8000. d0> -> -1 }t INCORRECT RESULT: t{     $8000. d0> -> -1 }t ok
   > t{     $8001. d0> -> -1 }t INCORRECT RESULT: t{     $8001. d0> -> -1 }t ok
   > t{    $10000. d0> -> -1 }t ok
   > t{ $00000000. d0> ->  0 }t ok
   > t{ $00000008. d0> -> -1 }t ok
   > t{ $00000080. d0> -> -1 }t ok
   > t{ $00000800. d0> -> -1 }t ok
   > t{ $00008000. d0> -> -1 }t INCORRECT RESULT: t{ $00008000. d0> -> -1 }t ok
   > t{ $00080000. d0> -> -1 }t ok
   > t{ $00800000. d0> -> -1 }t ok
   > t{ $08000000. d0> -> -1 }t ok
   > t{ $80000000. d0> ->  0 }t INCORRECT RESULT: t{ $80000000. d0> ->  0 }t ok
   > t{ $80000000. d0> ->  0 }t INCORRECT RESULT: t{ $80000000. d0> ->  0 }t ok
   > t{ $80000008. d0> ->  0 }t INCORRECT RESULT: t{ $80000008. d0> ->  0 }t ok
   > t{ $80000080. d0> ->  0 }t INCORRECT RESULT: t{ $80000080. d0> ->  0 }t ok
   > t{ $80000800. d0> ->  0 }t INCORRECT RESULT: t{ $80000800. d0> ->  0 }t ok
   > t{ $80008000. d0> ->  0 }t ok
   > t{ $80080000. d0> ->  0 }t INCORRECT RESULT: t{ $80080000. d0> ->  0 }t ok
   > t{ $80800000. d0> ->  0 }t INCORRECT RESULT: t{ $80800000. d0> ->  0 }t ok
   > t{ $88000000. d0> ->  0 }t INCORRECT RESULT: t{ $88000000. d0> ->  0 }t ok
   > t{ $FFFFFFFF. d0> ->  0 }t ok
   > t{ $FFFF7FFF. d0> ->  0 }t INCORRECT RESULT: t{ $FFFF7FFF. d0> ->  0 }t ok
   time:  9.46132898331  seconds


Adding a new Function and the Joys of ``rjmp``
..............................................


So I set out to add another assembly function :command:`d0>e0` to my
AmForth-System, starting with a copy of :command:`d0>`. I created a
new file ``words/ew-d-greaterzero.asm`` and added its name to
``dict_appl.inc``. The first round of error messages:

.. code-block:: none

    .../avr8\words/d-greaterzero.asm(4): error: Duplicate label: 'VE_DGREATERZERO'
    .../avr8\words/d-greaterzero.asm(9): error: Duplicate label: 'XT_DGREATERZERO'
    .../avr8\words/d-greaterzero.asm(11): error: Duplicate label: 'PFA_DGREATERZERO'

This is ok, because these labels are now used twice. So we rename them
in the additional definition. The second round of error messages is a
little more subtle:


.. code-block:: none

    words/ew-d-greaterzero.asm(17): error: Relative branch out of reach
    words/ew-d-greaterzero.asm(18): error: Relative branch out of reach
    words/ew-d-greaterzero.asm(19): error: Relative branch out of reach


Oh my! After staring at it for a bit it dawned on me, that the *tail
call optimization*, i.e. ``rjmp PFA_ZERO1`` did not work, because the
new word was included too far away for the available address range of
``rjmp``; it could not reach ``PFA_ZERO1`` or ``PFA_TRUE1``. I solved
this by copying the relevant code and changing the labels. Including
this function into the ``nrww``-section did not work immediately, so I
decided to copy the missing pieces.

.. code-block:: asm

    VE_DGREATERZERO_E0:
        .dw $ff05
        .db "d0>e0",0
        .dw VE_HEAD
        .set VE_HEAD = VE_DGREATERZERO_E0
    XT_DGREATERZERO_E0:
        .dw PFA_DGREATERZERO_E0
    PFA_DGREATERZERO_E0:
        cp tosl, zerol
        cpc tosh, zeroh
        loadtos
        cpc tosl, zerol
        cpc tosh, zeroh
        brlt PFA_ZERO_EW1           ; test negative flag
        brbs 1, PFA_ZERO_EW1        ; test zero flag
        rjmp PFA_TRUE_EW1
    
    ;;; FALSE
    PFA_ZERO_EW1:
        movw tosl, zerol
        jmp_ DO_NEXT
    
    ;;; TRUE
    PFA_TRUE_EW1:
        ser tosl
        ser tosh
        jmp_ DO_NEXT


This code could be assembled and loaded. Test cases for
:command:`d0>e0` did produce the same errors as the original
:command:`d0>` --- so we were good to go.


Unveiling the Error
...................

Reading the AVR Instruction Set Document did not immediately reveal,
why things went wrong. It occured to me that maybe loading the lower
half of the argument later was somehow producing an undesired effect.
So I copied the most significant word into temporary registers
``temp0`` and ``temp1``, then called ``loadtos``. Now all four bytes
were available for inspection.

Then I did the comparison against ``zerol`` of all bytes, but in a
different order: from least significant byte to most significant byte.
This was a change from the original function!

.. code-block:: asm

    VE_DGREATERZERO_E0:
        .dw $ff05
        .db "d0>e0",0
        .dw VE_HEAD
        .set VE_HEAD = VE_DGREATERZERO_E0
    XT_DGREATERZERO_E0:
        .dw PFA_DGREATERZERO_E0
    PFA_DGREATERZERO_E0:
    
        mov temp1, tosh             ; copy high word to temp space
        mov temp0, tosl             
        loadtos                     ; load low word
        cp  tosl,  zerol            ; compare against zero, start from LSByte
        cpc tosh,  zeroh            ; . order is significant
        cpc temp0, zerol            ; . because we test "less than" (brlt)
        cpc temp1, zeroh            ; .
                                    
        brlt PFA_ZERO_EW1           ; if the MSBit of d:arg is set (negative), we are done (false).
        brbs 1, PFA_ZERO_EW1        ; if all 4 Bytes of d:arg are zero, we are done (false).
            
        rjmp PFA_TRUE_EW1           ; if we get this far, d:arg was positive! (true)
    
    ;;; FALSE
    PFA_ZERO_EW1:
        movw tosl, zerol
        jmp_ DO_NEXT
    
    ;;; TRUE
    PFA_TRUE_EW1:
        ser tosl
        ser tosh
        jmp_ DO_NEXT


And to my surprise and relief, this function passed all tests! But
why?

Well, after some more staring it dawned on me. The original code did
inspect the four bytes in the order ``word_H.l word_H.h word_L.l
word_L.h``. The last byte inspected would determine, whether the MSBit
was set or not. If it was set, then the argument was negative, right?
The last byte inspected originally was ``word_L.h`` --- that explains
the error.

Testing the ``zero flag`` does not depend on the order of inspection,
but testing the ``less than flag`` does.


But can we do better?
.....................


Now we could commit this function and be done. However: copying the
high word seems like a waste of cycles somehow, doesn't it? Yes it
does. If we just inspect ``word_H.h`` and see if that is negative, we
are done already, right? Yes. So can't we exit prematurely then? Of
course, we can.


.. code-block:: asm

    ...
    PFA_DGREATERZERO_E1:
            cp  tosh, zeroh
            brlt PFA_ZERO_EW1       ; if the MSBit of d:arg ist negative, we are done (false).
    ...


Well --- the test cases produced funny results, of course. That is why
they are repeatable with almost no effort! While we can certainly
decide on the MSBit, we should clean up the stack before exiting.

.. code-block:: asm

    ...
    PFA_DGREATERZERO_E1:
            cp  tosh, zeroh
            brlt PFA_DGREATERZERO_E2 ; if the MSBit of d:arg ist negative, we are done (false).
    ...
    
    PFA_DGREATERZERO_E2:
            loadtos
            rjmp PFA_ZERO_EW1


This works, the new branch corresponds to ``drop 0``.

But then Bernd came along and said: Why don't you use ``zero nip``
instead? Well, yes I could indeed. In the end, I counted the
instructions and decided for that.

.. code-block:: asm

    ...
    PFA_DGREATERZERO_E2:
            movew tosl, zerol
            rjmp PFA_NIP_EW1
    
    ;;; NIP
    PFA_NIP_EW1:
        adiw yl, 2
        jmp_ DO_NEXT


Fixing ``avr8/words/g-greaterzero.asm``
.......................................

So, what does :command:`d0>` really need to do?

#. **If** the highest bit of the double word argument on the stack is
   set, this number is negative and we are done with the result
   ``false``. Well almost --- we either need to ``drop zero`` or to
   ``zero nip`` to get the stack right.

#. **Else If** all (four) bytes of the double word argument are zero,
   then the argument was zero, the answer is ``false`` and we are
   done.
  
#. **Else** we have a positive argument and the result is ``true``.


So the changed version looks like this now:


.. code-block:: asm

    ; ( d -- flag )
    ; Compare
    ; compares if a double double cell number is greater 0
    VE_DGREATERZERO:
        .dw $ff03
        .db "d0>",0
        .dw VE_HEAD
        .set VE_HEAD = VE_DGREATERZERO
    XT_DGREATERZERO:
        .dw PFA_DGREATERZERO
    PFA_DGREATERZERO:
        cp tosh, zeroh
        brlt PFA_DGREATERZERO_FALSE ; if MSBit is set, d:arg is negative, we are done (false).
        cpc tosl, zerol
        loadtos
        cpc tosl, zerol
        cpc tosh, zeroh
        brbs 1, PFA_ZERO1           ; if all 4 Bytes of d:arg are zero, we are done (false).
        rjmp PFA_TRUE1              ; if we get this far, d:arg was positive! (true)
    PFA_DGREATERZERO_FALSE:
        movw tosl, zerol            ; ZERO
        rjmp PFA_NIP                ; NIP


This roughly corresponds to a Forth version like this

.. code-block:: forth

    : d0> ( d -- f )
        dup $8000 and if
            drop false nip     \ d is negative
        else
            0= swap 0= and if
                false          \ d is zero
            else
                true           \ d is positive
            then
        then
    ;


Epilogue
........


As usual: *Afterwards, everything is obvious!*

I would like to thank Martin Nicholas for reporting this, Tristan for
adding a few observations, Bernd and Anton for helpful comments. This
code is going to be the first commit on the AmForth repository as the
new maintainer.
