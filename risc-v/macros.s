
# macros
#   x3 TOS
#   x4 SP
#

.macro NEXT
   ret
.endm

.macro PUSHTOS
  addi x4, x4, -4
  sw x3, 0(x4)
.endm

