
COLON Flag_visible, "ms", MS

XT_MS_LOOP:
.word XT_1MINUS
.word XT_DUP
.word XT_DOLITERAL
.word 43
.word XT_PLUS
.word XT_EMIT
.word XT_1MS
.word XT_DOCONDBRANCH
.word XT_MS_LOOP
.word XT_DROP
.word XT_EXIT