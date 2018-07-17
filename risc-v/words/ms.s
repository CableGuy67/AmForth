
COLON Flag_visible, "ms", MS

XT_MS_LOOP:
  .word XT_1MINUS
  .word XT_1MS
  .word XT_DUP,XT_ZEROEQUAL
  .word XT_DOCONDBRANCH
  .word XT_MS_LOOP
.word XT_DROP,XT_EXIT
