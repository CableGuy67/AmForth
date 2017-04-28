
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

`Version 4 </pr/Recognizer-rfc-D.html>`__ `(pdf) </pr/Recognizer-rfc-D.pdf>`__, 
`(txt) </pr/Recognizer-rfc-D.text>`__  

Forth `source code </pr/Recognizer-D.frt>`__ and `test code </pr/Recognizer-D-test.frt>`__
require `Stack.frt </pr/Stack.frt>`__ and `tester.fs </pr/tester.fs>`__.

Most changes are only wording changes. Most importandly 
many of the key words are renamed to better ones. They now 
describe what they do in a less confusing way 
(I hope). No changes were made to the stack 
effect so all existing code continues to work 
with a simple search and replace.

+---------------+---------------+
|    v3         |    v4         |
+---------------+---------------+
| recognizer    | rec-stack     |
+---------------+---------------+
| recognizer:   | dt-token:     |
+---------------+---------------+
| do-recognizer | recognize     |
+---------------+---------------+
| r>*           | dt>*          |
+---------------+---------------+
| r:fail        | dt:null       |
+---------------+---------------+

non-normative wording changes

+---------------+---------------+
|    v3         |    v4         |
+---------------+---------------+
| rec:word      | rec:find      |
+---------------+---------------+
| r:word        | dt:xt         |
+---------------+---------------+
| r:num         | dt:num        |
+---------------+---------------+
| r:dnum        | dt:dnum       |
+---------------+---------------+
| r:float       | dt:float      |
+---------------+---------------+
| r:name        | dt:nt         |
+---------------+---------------+

The data type token DT is not new actually. It
got only a more prominent role since it is 
one result of the parsing process but is not 
related to recognizers themselves. It provides
information about the data type and how to handle 
a certain data type (hence the name) inside the 
interpreter. It is not relevant where it comes
from.

The gforth team suggests that the ``DT>x`` words should have 
a different stack effect. ``DT>COMP ( i*x DT:TOKEN -- j*y XT )``

The input is what comes from the recognizer parsing words, the
result should be feedable directly to ``EXECUTE`` to achieve the
desired semantics. The words may change the result set too.
In the reference implementation this is not used however. 

The primary purpose of this seems to be an optimization and
an unification of the name token and the data type token for 
named words), so that DT>COMP becomes identical to NAME>COMPILE 
for name tokens.


.. A less radical rename of the keywords and concepts is a modified 
   `version 4 </pr/Recognizer-rfc-D1.html>`__ (`(pdf) </pr/Recognizer-rfc-D1.pdf>`__. 
   There is no real change however, every version 4 recognizer works with this
   one too, only search-and-replace the word names. `Sourccode </pr/Recognizer-D1.frt>`__ 
   and `test code </pr/Recognizer-D1-test.frt>`__.

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