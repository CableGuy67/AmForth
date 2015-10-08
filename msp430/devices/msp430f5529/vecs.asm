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
; 430g2553vecs.asm: Interrupt Vectors - MSP430G2553
; B. Rodriguez  26 oct 2012

; Revision History
;  1 mar 2014 bjr - adapted for naken_asm from vecs430g2553.s43.

; ----------------------------------------------------------------------
; Interrupt vectors are located in the range FFE0-FFFFh.

        .org 0FFFEh

        DC16  reset       ; FFFE - Reset
