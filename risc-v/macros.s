
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

# start of flash dictionary. The 0 is the stop marker
.macro STARTDICT
.word 0
9: # forth-wordlist
6: # environment wordlist
.endm

# save the beginning of the wordlists
.macro ENDDICT
CONSTANT "dp", DP
.word 9b
.set DPSTART, 9b
CONSTANT "edp", EDP
.word 6b
.equ HERESTART, rampointer
.endm

.macro STRING string
    .word XT_DOSLITERAL
    .byte 8f - 7f
7:  .ascii "\string"
8:  .p2align 2
.endm

.macro ramallot Name, Length 
  .equ RAM_lower_\Name, rampointer     # \Name at
  .set rampointer, rampointer + \Length
  .equ RAM_upper_\Name, rampointer     # \Name at
.endm

.equ Flag_invisible,  0xFFFFFFFF
.equ Flag_visible,    0x00000000

.equ Flag_immediate,  0x0010
.equ Flag_value,      0x0020
.equ Flag_defer,      0x0040

.equ Flag_ramallot,   Flag_visible | 0x0100      # Ramallot means that RAM is reserved and initialised by catchflashpointers for this definition on startup
.equ Flag_variable,   Flag_ramallot| 1           # How many 32 bit locations shall be reserved ?
.equ Flag_2variable,  Flag_ramallot| 2

.macro HEADER Flags, Name, Label, PFA
    .p2align 2
VE_\Label:
    .word 9b          # Insert Link
9:  .word \Flags      # Flag field
    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign
   XT_\Label: .word \PFA
   PFA_\Label: 
.endm

.macro CODEWORD Flags, Name, Label
    HEADER \Flags, "\Name", \Label, PFA_\Label
.endm

.macro COLON Flags, Name, Label
    HEADER \Flags, "\Name", \Label, DOCOLON
.endm

.macro IMMED Name, Label
    COLON Flag_visible|Flag_immediate, \Name, \Label
.endm


.macro VARIABLE Name, Label
   HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOVARIABLE
   .word rampointer
   .set rampointer, rampointer+4
.endm

.macro VALUE Name, Label
    HEADER Flag_visible|Flag_value, "\Name", \Label, PFA_DOVALUE
   .word rampointer
   .set rampointer, rampointer+4
.endm

.macro CONSTANT Name, Label
    HEADER Flag_visible, "\Name", \Label, PFA_DOVARIABLE
.endm

.macro DATA Name, Label
    HEADER Flag_visible, "\Name", \Label, PFA_DODATA
.endm

.macro NONAME Label
   XT_\Label: .word DOCOLON
   PFA_\Label: 
.endm

.macro HEADLESS Label
   XT_\Label: .word PFA_\Label
   PFA_\Label: 
.endm

.macro DEFER Name, Label
    HEADER Flag_visible|Flag_defer, "\Name", \Label, PFA_DO_DEFER
.endm

.macro ENVIRONMENT Flags, Name, Label
    .p2align 2
VE_ENV_\Label:
    .word 6b          # Insert Link
6:
    .word \Flags      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2        # Realign

   XT_ENV_\Label: .word DOCOLON
   PFA_ENV_\Label:
.endm


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
