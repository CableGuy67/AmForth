
COLON Flag_visible, "header", HEADER # ( addr len wid -- nt )

#  macro HEADER
#     .p2align 2
# VE_\Label:
#     .word 9b          # Insert Link
# 9:  .word \Flags      # Flag field
#     .byte 8f - 7f     # Calculate length of name field
# 7:  .ascii "\Name"    # Insert name string
# 8:  .p2align 2        # Realign
    .word XT_OVER,XT_GREATERZERO # check length info
    .word XT_DOCONDBRANCH, PFA_HEADER1
    # word with non-zero length
    .word XT_FETCH
    .word XT_COMMA # backward link
    .word XT_HERE,XT_TO_R # NFA
    .word XT_DOLITERAL
    .word Flag_invisible           # all flags are off (e.g. immediate)
    .word XT_COMMA
    # len shall fit into count'able string's
    .word XT_DOSCOMMA
    .word XT_R_FROM
    .word XT_EXIT

PFA_HEADER1:
    # -16: attempt to use zero length string as a name
    .word XT_DOLITERAL
    .word -16
    .word XT_THROW
