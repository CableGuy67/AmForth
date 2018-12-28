CODEWORD "abs", ABS @ ( n1 -- |n1| )
  cmp tos, #0
  it lt
  neglt tos, tos
NEXT
