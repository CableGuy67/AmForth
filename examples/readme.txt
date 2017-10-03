This folder contains some example codes not
related to any application.

easter.frt: calculates the date of easter. almost unmodfied version
    of Will Baden's code

fib.frt: simple benchmark. calculate a fibonacci number using
    different algorithm.

sieve.frt: not-so simple benchmark modelled after the sieve code
    of Marcel Hendrix. Uses single bits to store the is-prim flag.

run-hayes.frt: demonstrate the use of the amforth-upload.py utility 
    and the special #include syntax. The test itself is a slightly
    modified HAYES test suite

queens.frt: solves the queens problem for various size, maybe useful
  as a benchmark.

ascii.frt: prints an ascii table on screen

life.frt: Conveys game of life. Its very memory intensive, the example
   code works on an Atmega16, but a bigger one would allow larger
   worlds.

rec-*.frt: Collection of various recognizers. They enable new native
   data types and modify the behaviour of the interpreter.

sierpinski.frt: simple fractal generator. Illustrates the use of
   the amforth-shell to include library files.

co.frt: co routines aka subroutines for nonpreemtive multitasking.
   Examples on how to use them are included.

many.frt: Repeat the input line until a key is hit. Use it with care
   since it can cause a lot of trouble. Since the input line is re-parsed
   every time, it is much slower than a compiled word.

stack.frt: Generic stack operations. Implements a independent stack, 
   see ../tests/stack-test.frt for a Hayes test suite.
