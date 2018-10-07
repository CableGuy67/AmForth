
# macros
#   x2/SP RSP Return Stack Pointer
#   x3 TOS Top Of Stack
#   x4 DSP Data Stack Pointer
#   x5 temp 
#   x6 temp
#   x7 temp
#   x8 loop index
#   x9 loop limit
#   x10..x15 temp
#   x16 IP  Forth VM IP register (ITC Instruction Pointer)
#   x17 W   Forth VM W register
#   x18 user pointer UP

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
  loadtos
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


# start of flash dictionary. The 0 is the stop marker
.macro STARTDICT
.text
.word 0
97: # csr-wordlist
98: # environment
99: # forth-wordlist
.endm

# save the beginning of the wordlists
.macro ENDDICT
CONSTANT "csr-wordlist", CSR_WORDLIST, 97b
CONSTANT "edp", EDP, 98b
CONSTANT "fdp", FDP, 99b
.set DPSTART, 99b
.equ HERESTART, rampointer
.endm

.macro STRING string
    .word XT_DOSLITERAL
    .byte 8f - 7f
7:  .ascii "\string"
8:  .p2align 2,0x0f
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
.equ Flag_init,       0x0080

.equ Flag_ramallot,   Flag_visible | 0x0100      # Ramallot means that RAM is reserved and initialised by catchflashpointers for this definition on startup
.equ Flag_variable,   Flag_ramallot| 1           # How many 32 bit locations shall be reserved ?
.equ Flag_2variable,  Flag_ramallot| 2

.macro HEADER Flags, Name, Label, PFA
    .p2align 2,0xfe
VE_\Label:
    .word 99b         # Insert Link
99: .word \Flags      # Flag field
    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2,0xff        # Realign
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

.macro USER Name, Label, UOffset
   HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOUSER
   .word \UOffset
   .equ USER_\Label,\UOffset # for listing
.endm

.macro VALUE Name, Label, Default
    HEADER Flag_visible|Flag_value|Flag_init, "\Name", \Label, PFA_DOVALUE
   .word rampointer
    .equ RAM_\Label,rampointer # for listing
   .set rampointer, rampointer+4
   .word \Default
   .word XT_FETCH
   .word XT_STORE
.endm

.macro DEFER Name, Label, XT
    HEADER Flag_visible|Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .word rampointer
    .equ DEFER_RAM_\Label,rampointer # for listing
   .set rampointer, rampointer+4
   .word \XT
   .word XT_FETCH
   .word XT_STORE
.endm

.macro CONSTANT Name, Label, NUM
    HEADER Flag_visible, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
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

.macro ENVIRONMENT Name, Label
    .p2align 2,0xf0
VE_ENV_\Label:
    .word 98b          # Insert Link
98:
    .word Flag_visible      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2,0xf0        # Realign

   XT_ENV_\Label: .word DOCOLON
   PFA_ENV_\Label:
.endm

.macro CSR NUM, Name
    .p2align 2,0xf0
VE_CSR_\Name:
    .word 97b               # Insert Link
97: .word Flag_visible      # Flag field

    .byte 8f - 7f     # Calculate length of name field
7:  .ascii "\Name"    # Insert name string
8:  .p2align 2,0xf0   # Realign

   XT_CSR_\Name: .word PFA_CSR_\Name
   PFA_CSR_\Name:
     savetos
     csrr x3, \NUM
   NEXT
.endm
