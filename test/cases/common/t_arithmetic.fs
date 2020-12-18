\ t_arithmetic.fs

decimal
testing addition
t{ 1 1     + -> 2      }t
t{ 1 1     + -> 10     }t  \ incorrect
t{ $ffff 1 + -> 0      }t

testing subtraction
t{ 1 1     - -> 0      }t
t{ 0 1     - -> -1     }t
t{ $ffff 1 - -> $fffe  }t
t{ 21 4    - -> 16     }t  \ incorrect
t{ 21 4    - -> 17     }t

testing multiplication
t{ 0 -1     * -> 0     }t
t{ $ffff -1 * -> $efff }t  \ incorrect
t{ $ffff -1 * -> 1     }t

\ fin
