; ----------------------------------------------------------------------
; CamelForth for the Texas Instruments MSP430 
; (c) 2009 Bradford J. Rodriguez.
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
; deps430.s43: CPU and Model Dependencies - MSP430F1611
; B. Rodriguez  4 Jan 09

;   Forth words are documented as follows:
;x   NAME     stack -- stack    description
;   where x=C for ANS Forth Core words, X for ANS
;   Extensions, Z for internal or private words.
;
; Indirect-Threaded Forth model for T.I. MSP430
;   cell size is   16 bits (2 bytes)
;   char size is    8 bits (1 byte)
;   address unit is 8 bits (1 byte), i.e., addresses are byte-aligned.
; ----------------------------------------------------------------------

; ----------------------------------------------------------------------
; ALIGNMENT AND PORTABILITY OPERATORS 
; Many of these are synonyms for other words,
; and so are defined as CODE words.
.include "words/align.asm"
.include "words/aligned.asm"
.include "words/cellplus.asm"
.include "words/cells.asm"
.include "words/to-body.asm"
.include "words/comma-jmp.asm"

; ----------------------------------------------------------------------
; CONTROL STRUCTURES 
; These words allow Forth control structure words
; to be defined portably.
.include "words/comma-dest.asm"
.include "words/store-dest.asm"

; ----------------------------------------------------------------------
; HEADER STRUCTURE 
; The structure of the Forth dictionary headers (name, link, immediate 
; flag, and "smudge" bit) does not necessarily differ across CPUs.  This
; structure is not easily factored into distinct "portable" words; 
; instead, it is implicit in the definitions of FIND and CREATE, and 
; also in NFA>LFA, NFA>CFA, IMMED?, IMMEDIATE, HIDE, and REVEAL.
; These words must be (substantially) rewritten if either the header 
; structure or its inherent assumptions are changed.

