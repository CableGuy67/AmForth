
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

.macro ramallot Name, Length 
  .equ RAM_lower_\Name, rampointer     # \Name at
  .set rampointer, rampointer + \Length
  .equ RAM_upper_\Name, rampointer     # \Name at
.endm

.macro VARIABLE Name, Label
    .p2align 2
VE_\Label:
9:  .word 9f          # Insert Link
    .word Flag_visible|Flag_variable      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

   XT_\Label: .word PFA_DOVARIABLE
   PFA_\Label: .word rampointer
   .set rampointer, rampointer+4
.endm

.macro Definition_EndOfCore Flags, Name
    .p2align 2
    #.equ Dictionary_\@, .  # Labels for a more readable assembler listing only

9:  .word FlashDictionaryAnfang # Insert Link: FlashDictionaryAnfang
    .word \Flags      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

    #.equ Code_\@, .        # Labels for a more readable assembler listing only
.endm    


  .equ Flag_invisible,  0xFFFFFFFF
  .equ Flag_visible,    0x00000000
  
  
.equ Flag_immediate,  Flag_visible | 0x0010
.equ Flag_inline,     Flag_visible | 0x0020
.equ Flag_immediate_compileonly, Flag_visible | 0x0030 # Immediate + Inline

.equ Flag_ramallot,   Flag_visible | 0x0080      # Ramallot means that RAM is reserved and initialised by catchflashpointers for this definition on startup
.equ Flag_variable,   Flag_ramallot| 1           # How many 32 bit locations shall be reserved ?
.equ Flag_2variable,  Flag_ramallot| 2

.equ Flag_foldable,   Flag_visible | 0x0040 # Foldable when given number of constants are available.
.equ Flag_foldable_0, Flag_visible | 0x0040
.equ Flag_foldable_1, Flag_visible | 0x0041
.equ Flag_foldable_2, Flag_visible | 0x0042
.equ Flag_foldable_3, Flag_visible | 0x0043
.equ Flag_foldable_4, Flag_visible | 0x0044
.equ Flag_foldable_5, Flag_visible | 0x0045
.equ Flag_foldable_6, Flag_visible | 0x0046
.equ Flag_foldable_7, Flag_visible | 0x0047

.equ Flag_buffer, Flag_visible | 0x0100
.equ Flag_buffer_foldable, Flag_buffer|Flag_foldable  

.equ Flag_allocator, 0

.macro push_x1_x10_x11
  addi sp, sp, -12
  sw x1,  8(sp)
  sw x10, 4(sp)
  sw x11, 0(sp)   
.endm
.macro pop_x1_x10_x11
  lw x1,  8(sp)
  lw x10, 4(sp)
  lw x11, 0(sp)
  addi sp, sp, 12
.endm

.macro pushdouble register1 register2
  addi sp, sp, -8  
  sw \register1, 4(sp)
  sw \register2, 0(sp)  
.endm

.macro popdouble register1 register2
  lw \register1, 4(sp)
  lw \register2, 0(sp)
  addi x4, x4, 8
.endm

.macro pushda register # Push register on Datastack
  savetos
  mv x3, \register    
.endm

.macro popda register # Pop register from Datastack
  mv \register, x3
  lw x3, 0(x4)
  addi x4, x4, 4
.endm

.macro pushdaconst constant # Push constant on Datastack
  savetos
  li x3, \constant
.endm

.macro pushdadouble register1 register2 # Push register on Datastack
  addi x4, x4, -8
  sw x3, 4(x4)
  sw \register1, 0(x4)
  mv x3, \register2
.endm

.macro popdadouble register1 register2 # Pop register from Datastack
  mv \register1, x3
  lw \register2, 0(x4)
  lw x3, 4(x4)
  addi x4, x4, 8
.endm


.macro push_x10_x13
  addi sp, sp, -16
  sw x10, 12(sp)
  sw x11, 8(sp)
  sw x12, 4(sp)   
  sw x13, 0(sp)
.endm
.macro pop_x10_x13
  lw x10,  12(sp)
  lw x11, 8(sp)
  lw x12, 4(sp)
  lw x13, 0(sp)
  addi sp, sp, 16
.endm

.macro push_x10_x11
  addi sp, sp, -8
  sw x10,  4(sp)
  sw x11, 0(sp)
.endm
.macro pop_x10_x11
  lw x10,  4(sp)
  lw x11, 0(sp)
  addi sp, sp, 8
.endm

.macro pop_x10_x15
  lw x10, 20(sp)
  lw x11, 16(sp)
  lw x12, 12(sp)
  lw x13, 8(sp)
  lw x14, 4(sp)
  lw x15, 0(sp)    
  addi sp, sp, 24
.endm
