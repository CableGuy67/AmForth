
CODEWORD "aligned", ALIGNED
    adds tos, tos, #3
    movs r0, #3
    mvns r0, r0
    ands tos, tos, r0
NEXT
