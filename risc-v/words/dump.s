# RAM dump is byte oriented:
# 00B0 BD 3E 55 33 5B E6 C4 9B 4A 63 72 20 63 72 20 24   .>U3[...Jcr.cr.$
# 00C0 62 30 20 32 30 20 64 75 6D 70 20 63 72 20 63 72   b0.20.dump.cr.cr

#: ?ascii ( char -- printable-char )
#  dup $20 < if drop $2e
#           else dup $7e > 
#                if drop $2e then
#           then ;


COLON Flag_visible, "?ascii", QASCII
    .word XT_DUP, XT_DOLITERAL,0x20,XT_LESS
    .word XT_DOCONDBRANCH,PFA_QASCII1
	.word XT_DROP, XT_DOLITERAL,0x2e
	.word XT_DOBRANCH, PFA_QASCII2
PFA_QASCII1:
	.word XT_DUP, XT_DOLITERAL, 0x7e,XT_GREATER
	.word XT_DOCONDBRANCH,PFA_QASCII2
	.word XT_DROP, XT_DOLITERAL,0x2e
PFA_QASCII2:
    .word XT_EXIT


COLON Flag_visible, ".2hex", DOT2HEX
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
    .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT

#: .2hex base @ >r hex s>d <# # # #> type r> base ! ;
#: .4hex base @ >r hex s>d <# # # # # #> type r> base ! ;

COLON Flag_visible, ".4hex", DOT4HEX
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
    .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT

COLON Flag_visible, ".8hex", DOT8HEX
    .word XT_BASE,XT_FETCH,XT_TO_R,XT_HEX
    .word XT_S2D,XT_L_SHARP,XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP,XT_SHARP,XT_SHARP,XT_SHARP
    .word XT_SHARP_G,XT_TYPE
    .word XT_R_FROM,XT_BASE,XT_STORE
    .word XT_EXIT


#: dump ( addr count -- )
#  cr 0
#  do dup .8hex space
#     $10 0 do dup i + c@ .2hex space loop 2 spaces
#     $10 0 do dup i + c@ ?ascii emit loop
#     $10 + cr 
#  $10 +loop drop ;

COLON Flag_visible, "dump", DUMP

    .word XT_CR,XT_ZERO,XT_DODO,PFA_DUMP5
PFA_DUMP0:
      .word XT_DUP,XT_DOT8HEX,XT_SPACE
      .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO,PFA_DUMP2
  PFA_DUMP1:
        .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_DOT2HEX,XT_SPACE,XT_DOLOOP,PFA_DUMP1
  PFA_DUMP2:
      .word XT_SPACE,XT_SPACE
      .word XT_DOLITERAL,0x10,XT_ZERO,XT_DODO,PFA_DUMP4
  PFA_DUMP3:
        .word XT_DUP,XT_I,XT_PLUS,XT_CFETCH,XT_QASCII, XT_EMIT,XT_DOLOOP,PFA_DUMP3
  PFA_DUMP4:

      .word XT_DOLITERAL,0x10,XT_PLUS,XT_CR
PFA_DUMP5:
    .word XT_DOLITERAL,0x10,XT_DOPLUSLOOP,PFA_DUMP0
.word XT_DROP,XT_EXIT
