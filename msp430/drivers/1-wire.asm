;****h* 4e4th/4e-onewire
; NAME
;   4e-onewire
; SYNOPSIS
;   Dallas 1-wire drivers for 4e4th/CamelForth.
; DESCRIPTION
;   These are "bit-banging" 1-wire drivers for the MSP430G2553
;   MCU installed on a TI Launchpad board.
;   Currently configured to use P2.3, with MCLK=8 MHz.
; NOTES
;   4e4th configures MCLK = DCOCLK = 8 MHz (see 4e-init430G2553.s43).
;   Launchpad I/O pin usage:
;       P1.0 - LED1 output
;       P1.1 - UART
;       P1.2 - UART
;       P1.3 - SW2 input (internal pullup enabled)
;       P1.4 - output (configured by 4e4th)
;       P1.5 - output (configured by 4e4th)
;       P2.0
;       P2.1
;       P2.2
;       P2.3 - 1-wire I/O
;       P2.4
;       P2.5
;       P1.6 - LED2 output
;       P1.7
;   MSP430G2553 pins are capable of sourcing or sinking 6 mA.
;   Internal pullup resistor is 20-50 Kohm, typ. 35 Kohm, which
;   is too high, so an external pullup resistor is required.
;   Dallas DS18B20 data sheet suggests 4.7 Kohm pullup resistor.
;   Dallas App Note 132 suggests 1.1 Kohm pullup resistor.
;   Either external pullup is within limits for drive current.
;
;   Note that the MSP430 does not have open-drain outputs.
;   To simulate open-drain, a "0" is written to the pin's output 
;   register.  When a "1" is written to the pin's direction register,
;   the output is enabled and "0" is output.  When a "0" is written
;   to the direction register, the input is enabled and the pin is
;   Hi-Z (equivalent to an open-drain "1" output). 
; HISTORY
;   24 jun 14 bjr - re-released under BSD license.
;   23 nov 12 bjr - Changed to use P2.3 for 1-wire I/O.
;   19 nov 12 bjr - Refactored code to make OWSLOT primitive instead
;                   of OWTOUCH.
;   23 oct 12 bjr - Created.
; AUTHOR
;   B. J. Rodriguez
; COPYRIGHT
;   (c) 2012 Bradford J. Rodriguez.
;   All rights reserved.
;
;   Redistribution and use in source and binary forms, with or without 
;   modification, are permitted provided that the following conditions 
;   are met:
;
;   1. Redistributions of source code must retain the above copyright 
;   notice, this list of conditions and the following disclaimer.
;
;   2. Redistributions in binary form must reproduce the above copyright
;   notice, this list of conditions and the following disclaimer in the 
;   documentation and/or other materials provided with the distribution.
;
;   3. Neither the name of the copyright holder nor the names of its 
;   contributors may be used to endorse or promote products derived from 
;   this software without specific prior written permission.
;
;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
;   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
;   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
;   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
;   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
;   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
;   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
;   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
;   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
;   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
;   POSSIBILITY OF SUCH DAMAGE.
;******

; define port registers and pin to be used for 1-wire (P2.3)
#define OWIN    P2IN
#define OWOUT   P2OUT
#define OWDIR   P2DIR
#define OWREN   P2REN
#define OWBIT   BIT3

; define MCLK frequency in MHz.
MCLK    EQU     8

; Define a software delay of N usec for our MCLK freq (8 MHz)
; Uses scratch register X.
; Note that due to truncation, may delay as many as 2 MCLK cycles
; short of the specified period.  For 1-wire code this is ok,
; since we always have other instructions using at least 2 cycles.

.macro DELAY(usecs)
        MOV     #(((usecs*MCLK)-2)/3),X ; 2
.scope
loop:   SUB     #1,X                    ; 1n 
        JNZ     loop                    ; 2n 
.ends
.endm

.macro DELAY_500
        MOV     #(((500*MCLK)-2)/3),X ; 2
loop_500:   SUB     #1,X                    ; 1n 
        JNZ     loop_500                    ; 2n 
.endm

    
;****f* 4e-onewire/OWRESET
; NAME
;   OWRESET
; SYNOPSIS
;   OWRESET ( -- f )  Initialize 1-wire devices; return true if present
; DESCRIPTION
;   This configures the port pin used by the 1-wire interface, and then
;   sends an "initialize" sequence to the 1-wire devices.  If any device
;   is present, it will be detected.
;
;   Timing, per DS18B20 data sheet:
;   a) Output "0" (drive output low) for >480 usec.
;   b) Output "1" (let output float).
;   c) After 15 to 60 usec, device will drive pin low for 60 to 240 usec.
;      So, wait 75 usec and sample input.
;   d) Leave output high (floating) for at least 480 usec.
;******

        CODEHEADER(XT_OWRESET,7,"owreset")

        ; push old TOS onto stack
        SUB    #2,PSP           ; 1 
        MOV     TOS,0(PSP)      ; 4 
        
        ; preclear result in TOS
        MOV     #0,TOS

        ; initialize the pin used for the 1-wire.
        BIC.B   #OWBIT,OWDIR    ; make pin an input
        BIC.B   #OWBIT,OWOUT    ; make output bit a "0"
        BIC.B   #OWBIT,OWREN    ; disable internal pullup

        ; Delay >480 usec in case output pin had been low
        DELAY(500)
        
        ; Pull output low
        BIS.B   #OWBIT,&OWDIR    ; make pin output, sends "0"

        ; Delay >480 usec        
        DELAY(500)
        
        ; Critical timing period, disable interrupts.
        BIC     #8,SR           ; clear GIE bit

        ; Pull output high
        BIC.B   #OWBIT,OWDIR    ; make pin input, sends "1"

        ; Delay 75 usec
        DELAY(75)
        
        ; Sample input pin, set TOS if input is zero
        BIT.B   #OWBIT,OWIN
        JNZ     OWNONE
        MOV     #-1,TOS         ; if input zero, an 1-wire is present
OWNONE:
        ; End critical timing period, enable interrupts
        BIS     #8,SR           ; set GIE bit
        
        ; Delay rest of 480 usec (we've already delayed 75 usec)
        DELAY(405)

        ; we now have the result flag in TOS        
        NEXT

;****f* 4e-onewire/OWSLOT
; NAME
;   OWSLOT
; SYNOPSIS
;   OWSLOT ( c -- c' ) Write and read one bit to/from 1-wire.
; DESCRIPTION
;   The "touch byte" function is described in Dallas App Note 74.
;   It outputs a byte to the 1-wire pin, LSB first, and reads back
;   the state of the 1-wire pin after a suitable delay.
;   To read a byte, output $FF and read the reply data.
;   To write a byte, output that byte and discard the reply.
;
;   This function performs one bit of the "touch" operation --
;   one read/write "slot" in Dallas jargon.  Perform this eight
;   times in a row to get the "touch byte" function.
;
; PARAMETERS
;   The input parameter is xxxxxxxxbbbbbbbo where
;   'xxxxxxxx' are don't cares,
;   'bbbbbbb' are bits to be shifted down, and
;   'o' is the bit to be output in the slot.  This must be 1
;   to create a read slot.
;
;   The returned value is xxxxxxxxibbbbbbb where
;   'xxxxxxxx' are not known (the input shifted down 1 position),
;   'i' is the bit read during the slot.  This has no meaning
;   if it was a write slot.
;   'bbbbbbb' are the 7 input bits, shifted down one position.
;
;   This peculiar parameter usage allows OWTOUCH to be written as
;     OWSLOT OWSLOT OWSLOT OWSLOT OWSLOT OWSLOT OWSLOT OWSLOT 
;
; NOTES 
;   Interrupts are disabled during each bit.

;   Timing, per DS18B20 data sheet:
;   a) Output "0" for start period.  (> 1 us, < 15 us, typ. 6 us*)
;   b) Output data bit (0 or 1), open drain 
;   c) After MS from start of cycle, sample input (15 to 60 us, typ. 25 us*)
;   d) After write-0 period from start of cycle, output "1" (>60 us)
;   e) After recovery period, loop or return. (> 1 us)
;   For writes, DS18B20 samples input 15 to 60 usec from start of cycle.
;   * "Typical" values are per App Note 132 for a 300m cable length.

;   ---------        -------------------------------
;            \      /                        /
;             ------------------------------- 
;            a      b          c             d     e
;            |  6us |   19us   |    35us     | 2us |
;******

        CODEHEADER(XT_OWSLOT,6,"owslot")

        BIC     #0x100,TOS      ; preclear result bit in TOS

        ; disable interrupts
        BIC     #8,SR           ; clear GIE bit
        
        ; output a "0"
        BIS.B   #OWBIT,OWDIR    ; make pin output, sends "0"
        BIC.B   #OWBIT,OWOUT    ; just in case, ensure 0 is output
        
        ; delay 6 usec
        DELAY(6)
        
        ; output the LSB (no action required if LSB=0)
        BIT     #1,TOS
        JZ      OWSEND0
        BIC.B   #OWBIT,OWDIR    ; make pin input, sends "1"
OWSEND0:        
        
        ; delay 19 usec
        DELAY(19)
        
        ; sample the input (no action required if zero)
        BIT.B   #OWBIT,OWIN
        JZ      OWRECV0
        BIS     #0x100,TOS      ; if input=1, store 1 in high TOS
OWRECV0: RRA    TOS             ; shift TOS down 1 bit
        
        ; delay 35 usec
        DELAY(35)
        
        ; output a "1"
        BIC.B   #OWBIT,OWDIR    ; make pin input = Hi-Z
        
        ; enable interrupts
        BIS     #8,SR           ; set GIE bit
        
        ; delay 2 usec
        DELAY(2)
        
        ; note that NEXT will take 0.5 usec (4 clocks)
        ; we now have the received bit in the 0x80 bit of TOS.
        NEXT
