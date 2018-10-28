
\ http://www.forth200x.org/defined.html
\ adapted to non-counted strings

: [defined] parse-name find-xt dup if swap drop then ; immediate
: [undefined] postpone [defined] 0= ; immediate

\ ... and without postpone (Enoch, Feb-2013)
\ : [defined] parse-name find-xt if drop -1 else 0 then ; immediate
\ : [undefined] parse-name find-xt if drop 0 else -1 then ; immediate
