
#------------------------------------------------------------------------------
  CODEWORD Flag_foldable_1, "s>d", S2D # ( n - dl dh ) Single --> Double conversion
#------------------------------------------------------------------------------
  savetos
  srai x3, x3, 31    # Turn MSB into 0xffffffff or 0x00000000
  NEXT

#------------------------------------------------------------------------------
  COLON Flag_visible|Flag_foldable_3, "um/mod", UMSLASHMOD
um_slash_mod: # ( ud u -- u u ) Dividend Divisor -- Rest Ergebnis
             # 64/32 = 32 Rest 32
#------------------------------------------------------------------------------
  .word XT_ZERO, XT_UDSLASHMOD,XT_NIP,XT_NIP,XT_EXIT

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
