
\ A small example to read command line arguments 

\ Linux passes command line arguments on the initial return stack.
\ The initial return stack pointer is saved on entry and is available with the word "argv".

\ Offset to Arguments:
\  0  Number of arguments
\  4  Zero. argument, always available, gives the path and the name this binary is executed with.
\  8  First argument,  optional
\ 12  Second argument, optional
\ ...
\     Null pointer denotes end.

: type0 ( c-addr -- )
  begin
    dup c@
  while
    dup c@ emit
    1+
  repeat
  drop
;

: printarguments ( -- )

  cr 
  ." Number of arguments: " argv @ . cr

  argv @ 0 do
    ." Argument " i . ." : " argv i 1+ cells + @ type0 cr
  loop
;

printarguments
