
@ register usage
@ temporary r0, r1, r2, r3, r4, r5

tos     .req r6
psp     .req r7
FORTHW  .req r8
FORTHIP .req r9
UP      .req r10
rloopindex .req r11
rlooplimit .req r12

@ default register mapping
@ sp .req r13
@ lr .req r14
@ pc .req r15

.macro NEXT
    b DO_NEXT
    .ltorg
.endm

.macro STARTDICT
.word 0
9: @ forth-wordlist
6: @ environment wordlist
.endm

@ save the beginning of the wordlists
.macro ENDDICT
CONSTANT "fdp", FDP
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
  .equ RAM_lower_\Name, rampointer     @ \Name at
  .set rampointer, rampointer + \Length
  .equ RAM_upper_\Name, rampointer     @ \Name at
.endm

.equ Flag_invisible,  0xFFFFFFFF
.equ Flag_visible,    0x00000000

.equ Flag_immediate,  0x0010
.equ Flag_value,      0x0020
.equ Flag_defer,      0x0040
.equ Flag_init,       0x0080

.equ Flag_ramallot,   Flag_visible | 0x0100      
.equ Flag_variable,   Flag_ramallot| 1           
.equ Flag_2variable,  Flag_ramallot| 2

.macro HEADER Flags, Name, Label, PFA
    .p2align 2
VE_\Label:
    .word 9b          @ Insert Link
9:  .word \Flags      @ Flag field
    .byte 8f - 7f     @ Calculate length of name field
7:  .ascii "\Name"    @ Insert name string
8:  .p2align 2        @ Realign
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
   .set rampointer, rampointer+cellsize
.endm

.macro USER Name, Label, UOffset
   HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOUSER
    .word \UOffset
    .equ USER_\Label,\UOffset @ for listing
.endm

.macro VALUE Name, Label
    HEADER Flag_visible|Flag_value|Flag_init, "\Name", \Label, PFA_DOVALUE
   .word rampointer
    .equ RAM_\Label,rampointer @ for listing
   .set rampointer, rampointer+cellsize
.endm

.macro DEFER Name, Label
    HEADER Flag_visible|Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .word rampointer
    .equ DEFER_RAM_\Label,rampointer @ for listing
   .set rampointer, rampointer+cellsize
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
    .p2align 2
VE_ENV_\Label:
    .word 6b          @ Insert Link
6:
    .word Flag_visible      @ Flag field

    .byte 8f - 7f     @ Calculate length of name field
7:  .ascii "\Name"    @ Insert name string
8:  .p2align 2        @ Realign

   XT_ENV_\Label: .word DOCOLON
   PFA_ENV_\Label:
.endm

.macro savetos @ Push TOS on Datastack - a common, often used factor.
.ifdef m0core
    sub psp, #4
    str tos, [psp]
.else
    ldm psp!, {tos}
.endif
.endm

.macro loadtos
    ldr tos, [psp]
    add psp, #4
.endm

.macro pushda register @ Push register on Datastack
  savetos
  mov tos, \register
.endm

.macro popda register @ Pop register from Datastack
  mov \register, tos
  loadtos
.endm

.macro SEMIT register
0: ldr r0, =UARTFR
   ldr r0, [r0]
   ands r0, #TXFF
   bne 0b

   ldr r0, =UARTDR
   str \register, [r0]
.endm
