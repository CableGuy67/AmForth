; conditional assembly needs preparation
.set DICT_COMPILER2 = 0 ; 
.set cpu_msp430 = 1
.set cpu_avr8 = 0

.include "user.inc"

  .def zerol = r2
  .def zeroh = r3
  .def upl = r4
  .def uph = r5

  .def al  = r6
  .def ah  = r7
  .def bl  = r8
  .def bh  = r9

; internal
  .def mcu_boot      = r10
  .def erase_counter = r11

  .def temp4 = r14
  .def temp5 = r15

  .def temp0 = r16
  .def temp1 = r17
  .def temp2 = r18
  .def temp3 = r19

  .def temp6 = r20
  .def temp7 = r21

  .def tosl = r24
  .def tosh = r25

  .def wl = r22
  .def wh = r23

  .def xl = r26
  .def xh = r27
  .def yl = r28
  .def yh = r29
  .def zl = r30
  .def zh = r31

.macro loadtos
    ld tosl, Y+
    ld tosh, Y+
.endmacro

.macro savetos
    st -Y, tosh
    st -Y, tosl
.endmacro

;               F_CPU
;    µsec   16000000   14745600    8000000  1000000
;    1            16      14,74          8        1
;    10          160     147,45         80       10
;    100        1600    1474,56        800      100
;    1000      16000   14745,6        8000     1000
;
; cycles = µsec * f_cpu / 1e6
; n_loops=cycles/5
;
;     cycles already used will be subtracted from the delay
;     the waittime resolution is 1 cycle (delay from exact to +1 cycle)
;     the maximum delay at 20MHz (50ns/clock) is 38350ns
;     waitcount register must specify an immediate register
;
; busy waits a specfied amount of microseconds
.macro   delay(time)
      .set cycles = ( ( time * F_CPU ) / 1000000 )
      .if (cycles > ( 256 * 255 * 4 + 2))
        .error "MACRO delay - too many cycles to burn"
      .else
        .if (cycles > 6)
          .set  loop_cycles = (cycles / 4)      
          ldi   zl,low(loop_cycles)
          ldi   zh,high(loop_cycles)
delay_loop:
          sbiw  Z, 1
          brne  delay_loop
          .set  cycles = (cycles - (loop_cycles * 4))
        .endif
        .if (cycles > 0)
          .if   (cycles & 4)
            rjmp  pc+1
            rjmp  pc+1
          .endif
          .if   (cycles & 2)
            rjmp  pc+1
          .endif
          .if   (cycles & 1)
            nop
          .endif
        .endif
      .endif
.endmacro

.macro DSEG(name,length)
.set name=DSEGPTR
.set DSEGPTR=DSEGPTR+length
.endm

.macro ESEG(name,inital,length)
.set name=ESEGPTR
.set ESEGPTR=ESEGPTR+length
.endm
