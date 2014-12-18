; ----------------------------------------------------------------------
; CamelForth for the Texas Instruments MSP430 
; (c) 2013,2014 Bradford J. Rodriguez.
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; Commercial inquiries should be directed to the author at 
; 115 First St., #105, Collingwood, Ontario L9Y 4W3 Canada
; or via email to bj@camelforth.com
; ----------------------------------------------------------------------
; 430g2553save.asm - SAVE and RESTORE user area and variables
; B. Rodriguez 27 nov 2012
; ----------------------------------------------------------------------
; REVISION HISTORY
;  2 mar 2014 bjr - created from forth430g2553.s43 for naken_asm.

; SAVE erases the first 128 bytes of Info Flash, then
; copies the User Area and subsequent RAM variables there.
        HEADER(SAVE,4,"SAVE",DOCOLON)
        DW  U0,XT_DOLITERAL,USAVE,XT_DOLITERAL,INFO_SIZE
        DW  XT_2DUP,FLERASE,DTOI,XT_EXIT
        
; RESTORE copies the first 128 bytes of Info Flash to
; the User Area and subsequent RAM.
        HEADER(RESTORE,7,"RESTORE",DOCOLON)
        DW  XT_DOLITERAL,USAVE,U0,XT_DOLITERAL,INFO_SIZE
        DW  ITOD,XT_EXIT

; SCRUB erases the application area of the Program Flash,
; and then does COLD to reset the User Variables.
        HEADER(SCRUB,5,"SCRUB",DOCOLON)
        DW  XT_DOLITERAL,FLASHSTART,XT_DOLITERAL,(FLASHEND-FLASHSTART),FLERASE
        DW  XT_COLD,XT_EXIT
