; ----------------------------------------------------------------------
; CamelForth for the Texas Instruments MSP430 
; (c) 2009,2014 Bradford J. Rodriguez.
; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; Commercial inquiries should be directed to the author at 
; 115 First St., #105, Collingwood, Ontario L9Y 4W3 Canada
; or via email to bj@camelforth.com
; ----------------------------------------------------------------------
; 430f1611io.asm: Input/Output primitives - MSP430F1611


; ----------------------------------------------------------------------
; TERMINAL I/O (TARGET-SPECIFIC)

;C EMIT     c --    output character to console
        CODEHEADER(EMIT,4,"emit")
EMITLOOP:
        BIT.B   #UTXIFG0,&IFG1
        JZ      EMITLOOP
        MOV.B   TOS,&U0TXBUF
        MOV @PSP+,TOS
        NEXT

;C KEY      -- c      get character from keyboard
        CODEHEADER(KEY,3,"key")
KEYLOOP:
        BIT.B   #URXIFG0,&IFG1
        JZ      KEYLOOP
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        MOV.B   &U0RXBUF,TOS    ; read character into TOS
donoop:
donext: NEXT

;X KEY?     -- f    return true if char waiting
        CODEHEADER(KEYQ,4,"key?")
        SUB     #2,PSP          ; 1  push old TOS..
        MOV     TOS,0(PSP)      ; 4  ..onto stack
        BIT.B   #URXIFG0,&IFG1
        JNZ     TOSTRUE
        JMP     TOSFALSE

