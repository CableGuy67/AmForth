\ check for the 'c' syntax for single characters.
: rec-char ( addr len -- n rectype-num | rectype-null )
  3 = if \ a three character string
    dup c@ [char] ' = if \ starts with a '
      dup 2 + c@ [char] ' = if \ and ends with a '
        1+ c@ rectype-num exit
      then
    then
  then
  drop rectype-null
;
