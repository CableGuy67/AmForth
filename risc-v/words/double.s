#
#    Mecrisp-Quintus - A native code Forth implementation for RISC-V
#    Copyright (C) 2018  Matthias Koch
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Double number support

#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_1, "s>d", S2D # ( n - dl dh ) Single --> Double conversion
#------------------------------------------------------------------------------
  pushdatos
  srai x3, x3, 31    # Turn MSB into 0xffffffff or 0x00000000
  NEXT

#------------------------------------------------------------------------------
# --- Double star and slash ---
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_4, "ud*", UDSTAR
ud_star:
         # Unsigned multiply 64*64 = 64
         # ( ud1 ud2 -- ud )
#------------------------------------------------------------------------------
  push x1
  call udm_star
  ddrop
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_4, "udm*", UDMSTAR
udm_star: # Unsigned multiply 64*64 = 128
          # ( ud1 ud2 -- udl udh )
#------------------------------------------------------------------------------
  # Auf dem Datenstack: ( 1L 1H 2L 2H -- LL  L  H HH )
  #                       12  8  4  0 nach pushdatos
  #                        d  c  b  a    r0 r1 r2 r3
  # Benötige einen langen Ergebnisregister !

  
  push x1

  push x7
  push x8
  push x9

  push_x10_x13

  # ( d c b a )
  pushdatos
  lw x3, 4(x4)    # b
  pushdatos
  lw x3, 16(x4)   # d
  call um_star
  # ( d c b a  b*d-Low b*d-High )
  popda x11 # b*d-High
  popda x10 # b*d-Low, finished value

  # ( d c b a )

  pushdatos
  lw x3, 0(x4)   # a
  pushdatos
  lw x3, 12(x4)  # c
  call um_star
  # ( d c b a  a*c-Low a*c-High )
  popda x13 # a*c-High
  popda x12 # a*c-Low

  # ( d c b a )

  pushdatos
  lw x3, 0(x4)    # a
  pushdatos
  lw x3, 16(x4)   # d

  call um_star
  # ( d c b a  a*d-Low a*d-High )

  li x5, 0
  addc x12, x12, x3    # a*c-Low + a*d-High
  addc x13, x13, zero  # Carry
  drop

  li x5, 0
  addc x11, x11, x3 # a*d-Low + b*d-High
  addc x12, x12, zero # Carry
  addc x13, x13, zero # Carry
  drop

  # ( d c b a )

  pushdatos
  lw x3, 4(x4)    # b
  pushdatos
  lw x3, 12(x4)   # c

  call um_star
  # ( d c b a  b*c-Low b*c-High )

  li x5, 0
  addc x12, x12, x3 # a*c-Low + b*c-High + a*d-High
  addc x13, x13, zero # Carry
  drop

  li x5, 0
  addc x11, x11, x3 # b*c-Low + a*d-Low + b*d-High
  addc x12, x12, zero  # Carry
  addc x13, x13, zero  # Carry
  drop

  # ( d c b tos: a )
  mv x3, x13
  sw x12, 0(x4)
  sw x11, 4(x4)
  sw x10, 8(x4)

  pop_x10_x13

  pop x9
  pop x8
  pop x7

  pop x1
  NEXT


#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_3, "*/", STARSLASH # Signed scalar
  # ( u1 u2 u3 -- u1*u2/u3 ) With double length intermediate result
#------------------------------------------------------------------------------
  push x1
  to_r
  call m_star
  r_from
  call m_slash_mod
  nip
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_3, "*/mod", STARSLASHMOD # Signed scalar
  # ( u1 u2 u3 -- u1*u2/u3 ) With double length intermediate result
#------------------------------------------------------------------------------
  push x1
  to_r
  call m_star
  r_from
  call m_slash_mod
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_3, "um/mod", UMSLASHMOD
um_slash_mod: # ( ud u -- u u ) Dividend Divisor -- Rest Ergebnis
             # 64/32 = 32 Rest 32
#------------------------------------------------------------------------------
  push x1
  pushdaconst 0
  call ud_slash_mod
  drop
  nip
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_3, "m/mod", MSLASHMOD
              # Signed symmetric divide 64/32 = 32 remainder 32
m_slash_mod:  # ( d n -- n n )
#------------------------------------------------------------------------------
  push x1
  pushdatos                 # s>d
  srai x3, x3, 31           # Turn MSB into 0xffffffff or 0x00000000
  call d_slash_mod
  drop
  nip
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_4, "ud/mod", UDSLASHMOD
         # Unsigned divide 64/64 = 64 remainder 64
         # ( ud1 ud2 -- ud ud)
         # ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
#------------------------------------------------------------------------------
ud_slash_mod:


   # ( DividendL DividendH DivisorL DivisorH -- RemainderL RemainderH ResultL ResultH )
   #   8         4         0        tos      -- 8          4          0       tos


   # Shift-High Shift-Low Dividend-High Dividend-Low
   #        x13       x12           x11          x10

   push_x10_x13

   li x13, 0
   li x12, 0
   lw x11, 4(x4)
   lw x10, 8(x4)

   # Divisor-High Divisor-Low
   #         x15          x14

ud_slash_mod_internal:

   push x14
   push x15

   push x7
   push x8
   push x9
  
   mv x15, x3
   lw x14, 0(x4)

   # For this long division, we need 64 individual division steps.
   li x3, 64

3: 


    # Shift the long chain of four registers.
    li x5, 0

    addc x10, x10, x10
    addc x11, x11, x11
    addc x12, x12, x12
    addc x13, x13, x13

    # Compare Divisor with top two registers
    bltu x15, x13, 1f # Check high part first
    bltu x13, x15, 2f
    # cmp r3, r5 # Check high part first
    # bhi 1f
    # blo 2f

    bltu x12, x14, 2f # High part is identical. Low part decides.
    # cmp r2, r4 
    # blo 2f

    # Subtract Divisor from two top registers
1:  li x5, 0
    subc x12, x12, x14
    subc x13, x13, x15

    # subs r2, r4 # Subtract low part
    # sbcs r3, r5 # Subtract high part with carry

    # Insert a bit into Result which is inside LSB of the long register.
    addi x10, x10, 1
2:


   addi x3, x3, -1
   bne x3, zero, 3b

   # Now place all values to their destination.
   mv x3, x11    # Result-High
   sw x10, 0(x4) # Result-Low
   sw x13, 4(x4) # Remainder-High
   sw x12, 8(x4) # Remainder-Low

   pop x9
   pop x8
   pop x7

   pop_x10_x15
   NEXT


#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_4, "d/mod", DSLASHMOD
              # Signed symmetric divide 64/64 = 64 remainder 64
              # ( d1 d2 -- d d )
d_slash_mod:  # ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
#------------------------------------------------------------------------------
  # Check Divisor
  push x1

  # movs r0, tos, asr #31 # Turn MSB into 0xffffffff or 0x00000000
  # beq 2f
  bge x3, zero, 2f

    # ? / -
    call dnegate
    call dswap
    # movs r0, tos, asr #31 # Turn MSB into 0xffffffff or 0x00000000
    # beq 1f
    bge x3, zero, 1f

    # - / -
    call dnegate
    call dswap
    call ud_slash_mod

    call dswap
    call dnegate # Negative remainder
    call dswap
    pop x1
    NEXT

1:  # + / -
    call dswap
    call ud_slash_mod
    call dnegate  # Negative result
    pop x1
    NEXT

2:  # ? / +
    call dswap
    # movs r0, tos, asr #31 # Turn MSB into 0xffffffff or 0x00000000
    # beq 3f
    bge x3, zero, 3f

    # - / +
    call dnegate
    call dswap

    call ud_slash_mod

    call dnegate # Negative result
    call dswap
    call dnegate # Negative remainder
    call dswap
    pop x1
    NEXT

3:  # + / +
    call dswap
    call ud_slash_mod
    pop x1
    NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_visible|Flag_foldable_4, "d/", DSLASH
#------------------------------------------------------------------------------
  push x1
  call d_slash_mod
  call dnip
  pop x1
  NEXT

#------------------------------------------------------------------------------
CODEWORD Flag_foldable_4, "du<", DULESS
#------------------------------------------------------------------------------
du_less: 
  push x1
  call dminus
  drop
  addi x3, x5, -1
  xori x3, x3, -1
  pop x1
  NEXT

#------------------------------------------------------------------------------
CODEWORD Flag_foldable_4, "du>", DUGREATER  # Just swapped the order of registers
#------------------------------------------------------------------------------
  push x1
  call dswap
  call du_less
  pop x1
  NEXT


CODEWORD Flag_foldable_4, "d<", DLESS
#------------------------------------------------------------------------------
d_less:
  push_x1_x10_x11
 
  srai x10, x3, 31
  lw x11, 4(x4)
  srai x11, x11, 31

  call du_less

  xor x3, x3, x10
  xor x3, x3, x11

  pop_x1_x10_x11
  NEXT


#------------------------------------------------------------------------------
CODEWORD Flag_foldable_4, "d>", DGREATER  # Just swapped the order of registers
#------------------------------------------------------------------------------
  push x1
  call dswap
  call d_less
  pop x1
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_inline|Flag_foldable_2, "d0<", DZEROLESS # ( 1L 1H -- Flag ) Is double number negative ?
#------------------------------------------------------------------------------
  addi x4, x4, 4
  srai x3, x3, 31    # Turn MSB into 0xffffffff or 0x00000000
  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_2, "d0=", DZEROEQUAL # ( 1L 1H -- Flag )
#------------------------------------------------------------------------------
  lw x5, 0(x4)
  addi x4, x4, 4
  or x3, x3, x5

  sltiu x3, x3, 1
  addi x3, x3, -1
  xori x3, x3, -1

  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_4, "d<>", DNOTEQUAL # ( 1L 1H 2L 2H -- Flag )
#------------------------------------------------------------------------------
  popdadouble x5, x6
  #popda x5 # 2H
  #popda x6 # 2L
           # TOS: 1H

  xor x5, x5, x3
  drop
  xor x6, x6, x3

  or x3, x5, x6

  sltiu x3, x3, 1
  addi x3, x3, -1

  NEXT

#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_4, "d=", DEQUAL # ( 1L 1H 2L 2H -- Flag )
#------------------------------------------------------------------------------
  popdadouble x5, x6
  #popda x5 # 2H
  #popda x6 # 2L
           # TOS: 1H

  xor x5, x5, x3
  drop
  xor x6, x6, x3

  or x3, x5, x6

  sltiu x3, x3, 1
  addi x3, x3, -1
  xori x3, x3, -1

  NEXT
