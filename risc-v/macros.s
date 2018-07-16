
# macros
#   x2/SP RSP Return Stack Pointer
#   x3 TOS Top Of Stack
#   x4 DSP Data Stack Pointer
#   x17 W   Forth VM W register
#   x16 IP  Forth VM IP register (ITC Instruction Pointer)

.macro NEXT
    j DO_NEXT
.endm

.macro savetos
  addi x4, x4, -4
  sw x3, 0(x4)
.endm

.macro loadtos
  lw x3, 0(x4)
  addi x4,x4,4
.endm

.macro push register
  addi sp, sp, -4
  sw \register, 0(sp)
.endm

.macro pop register
  lw \register, 0(sp)
  addi sp, sp, 4
.endm


.macro HEADER Flags, Name, Label
    .p2align 2

9:  .word 9f          # Insert Link
    .word \Flags      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

.endm

.macro CODEWORD Flags, Name, Label
    .p2align 2
VE_\Label:
9:  .word 9f          # Insert Link
    .word \Flags      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

   XT_\Label: .word PFA_\Label
   PFA_\Label: 
.endm

.macro COLON Flags, Name, Label
    .p2align 2
VE_\Label:
9:  .word 9f          # Insert Link
    .word \Flags      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

   XT_\Label: .word DOCOLON
   PFA_\Label:
.endm
