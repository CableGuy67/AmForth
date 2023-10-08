
Recognizers
===========

The goal of a recognizer is to dynamically extent the Forth 
command interpreter and make it understand and handle new data 
formats as well as new synatax's. The present, 2nd generation
recognizers achieve this by generalizing the classic interpreter 
with an API to factor the components. Recognizers are portable 
across different forth's.

Recognizers are not a new concept for forth. They have been
discussed earlier.

* `compgroups.net/comp.lang.forth/additional-recognizers/734676 <http://compgroups.net/comp.lang.forth/additional-recognizers/734676>`__
  in 2003.
* `Number Parsing Hooks <https://groups.google.com/d/msg/comp.lang.forth/r7Vp3w1xNus/Wre1BaKeCvcJ>`__
  in 2007.
* Presentations held at Euroforth conferences 

    * `2012 <http://www.complang.tuwien.ac.at/anton/euroforth/ef12/papers/paysan-recognizers-ho.pdf>`__ (B. Paysan)
    * `2015 <http://www.complang.tuwien.ac.at/anton/euroforth/ef15/papers/ertl-recognizers-slides.pdf>`__ (A. Ertl)
    * `2016 <http://www.complang.tuwien.ac.at/anton/euroforth/ef16/papers/>`__ (A.Ertl with Video)


More recognizer examples are available at `The Forth Net <http://theforth.net>`__.

Version 4
---------

The Euroforth 2017 suggested some small wording changes and 
initiated a spin off stack RFD resulting in a much smaller 
recognizer RFD.

`Version 4 </pr/Recognizer-rfc-D.html>`__ `(pdf) </pr/Recognizer-rfc-D.pdf>`__, 
`(txt) </pr/Recognizer-rfc-D.text>`__  All discussions and remarks went into 
a new document `(html) </pr/Recognizer-rfc-D-comments.html>`__, 
`(pdf) </pr/Recognizer-rfc-D-comments.pdf>`__
`(text) </pr/Recognizer-rfc-D-comments.text>`__

Forth `source code </pr/Recognizer-D.frt>`__ and `test code </pr/Recognizer-D-test.frt>`__
require `Stack.frt </pr/Stack.frt>`__ and `tester.fs </pr/tester.fs>`__.

Outdated
--------

The `1st formal RFD </pr/Recognizer-rfc.html>`__  
`(pdf) </pr/Recognizer-rfc.pdf>`__, `(txt) </pr/Recognizer-rfc.text>`__  
was published at october, 3 2014. `Version 2 </pr/Recognizer-rfc-B.html>`__
`(pdf) </pr/Recognizer-rfc-B.pdf>`__, `(txt) </pr/Recognizer-rfc-B.text>`__  
has been published on september, 20 2015. It improves the proposed standard 
section and adds a long chapter discussing the recognizer design based on 
feedback from version 1. The 3rd version has been started immediately after
v2 due to a suggestion changing the `POSTPONE` action.
`Version 3 </pr/Recognizer-rfc-C.html>`__ `(pdf) </pr/Recognizer-rfc-C.pdf>`__, 
`(txt) </pr/Recognizer-rfc-C.text>`__.

The `Sourcecode </pr/Recognizer-C.frt>`__ requires `Stack.frt </pr/Stack.frt>`__. 
In the `Recognizer-Test </pr/Recognizer-C-test.frt>`__ are many tests and
example implementation for gforth, MPE's vfxlin and Swift-Forth from Forth Inc.

The papers linked below give some historical background information.

* `First Generation </pr/Recognizer-en.pdf>`__ is an all in one implementation.
* `Second Generation </pr/Recognizer2-en.pdf>`__ describes the factored component 
  approach.

Namespace RFD
--------------

An inofficial `Namespace RFD </pr/RFD-Namespace.pdf>`__.
