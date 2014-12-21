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
; itc430hilvl.asm - High Level Words - MSP430
; B. Rodriguez  4 Jan 09

;   Forth words are documented as follows:
;x   NAME     stack -- stack    description
;   where x=C for ANS Forth Core words, X for ANS
;   Extensions, Z for internal or private words.
; ----------------------------------------------------------------------
; REVISION HISTORY
;  1 mar 14 bjr - adapted from hilvl430.s43 for naken_asm.
; 22 dec 13 bjr - added XON/OFF logic to interpreter loop
; 27 nov 12 bjr - fixed S" IS" to use PARSE
; 13 nov 12 bjr - added PARSE, fixed ( to use PARSE.
; 12 nov 12 bjr - fixed FM/MOD.
; 17 jan 09 bjr - changed label _DP to DDP for compatibility with token
;   naming convention.  Now uses DEST macro to compute branch offsets.
; 11 jan 09 - modified QUIT for Xon/Xoff flow control
; 4 jan 09 - created from Camel86h.asm.

; SYSTEM VARIABLES & CONSTANTS ==================

.include "words/u-0.asm"

.include "words/to-in.asm"
.include "words/base.asm"
.include "words/state.asm"
.include "words/dp.asm"
.include "words/tick-source.asm"
.include "words/latest.asm"
.include "words/get-current.asm"
.include "words/hld.asm"
.include "words/lp.asm"
.include "words/idp.asm"
.include "words/newest.asm"
.include "words/allot.asm"
; user variables 26,28,30 tbd

.include "words/pad.asm"
.include "words/l-0.asm"
.include "words/r-0.asm"
.include "words/s-0.asm"
.include "words/tib.asm"
.include "words/tibsize.asm"
.include "words/bl.asm"


.include "words/uinit.asm"
.include "words/sharp-init.asm"

; ARITHMETIC OPERATORS ==========================
.include "words/s-to-d.asm"
.include "words/q-negate.asm"
.include "words/abs.asm"
.include "words/dnegate.asm"
.include "words/q-dnegate.asm"
.include "words/dabs.asm"
.include "words/m-star.asm"
.include "words/sm-rem.asm"
.include "words/fm-mod.asm"
.include "words/star.asm"
.include "words/slash-mod.asm"
.include "words/slash.asm"
.include "words/mod.asm"
.include "words/max.asm"
.include "words/min.asm"

; DOUBLE OPERATORS ==============================
.include "words/2-fetch.asm"
.include "words/2-store.asm"
.include "words/2drop.asm"
.include "words/2dup.asm"
.include "words/2swap.asm"

; INPUT/OUTPUT ==================================
.include "words/cr.asm"
.include "words/space.asm"
.include "words/spaces.asm"
.include "words/umin.asm"
.include "words/umax.asm"
.include "words/accept.asm"
.include "words/type.asm"

; HARVARD MODEL EXTENSIONS (split Code & Data)
.include "words/icount.asm"
.include "words/itype.asm"
.include "words/do-rquote.asm"
.include "words/do-squote.asm"
.include "words/rquote.asm"
.include "words/squote.asm"
.include "words/dot-quote.asm"
.include "words/sliteral.asm"

; NUMERIC OUTPUT ================================
; Numeric conversion is done l.s.digit first, so
; the output buffer is built backwards in memory.

; Some double-precision arithmetic operators are
; needed to implement ANSI numeric conversion.
.include "words/ud-slash-mod.asm"
.include "words/ud-star.asm"
.include "words/hold.asm"
.include "words/less-sharp.asm"
.include "words/sharp.asm"
.include "words/sharp-s.asm"
.include "words/sharp-greater.asm"
.include "words/sign.asm"
.include "words/u-dot.asm"
.include "words/dot.asm"
.include "words/decimal.asm"
.include "words/hex.asm"

.include "words/bounds.asm"
.include "words/pick.asm"
; DICTIONARY MANAGEMENT =========================
.include "words/here.asm"
.include "words/comma.asm"
.include "words/c-comma.asm"

; The following additional words support the
; "Harvard" model, with separate address spaces
; for Instructions (Code) and Data.  ANSI
; requires DP to manage the Data space, so a
; separate Instruction Dictionary Pointer, IDP,
; is added to manage the Code space.  Also added:
;   I@ IC@ I! IC! I->D D->I   (in the primitives)
;   ITYPE ICOUNT IWORD        (above)
;   IHERE IALLOT I, IC,       (below)
; It should be possible to convert the Harvard
; implementation to a combined-code-and-data
; system, by equating these words to their
; Data-space counterparts.
.include "words/i-here.asm"
.include "words/i-allot.asm"

; INTERPRETER ===================================
; Note that NFA>LFA, NFA>CFA, IMMED?, and FIND
; are dependent on the structure of the Forth
; header.  This may be common across many CPUs,
; or it may be different.
.include "words/source.asm"
.include "words/slash-string.asm"
.include "words/place.asm"
.include "words/parse.asm"
.include "words/word.asm"
.include "words/nfa-to-lfa.asm"
.include "words/nfa-to-cfa.asm"
.include "words/name2flags.asm"
.include "words/immediate-q.asm"
.include "words/find-name.asm"
.include "words/literal.asm"
.include "words/digit-q.asm"
.include "words/q-sign.asm"
.include "words/set-base.asm"
.include "words/to-number.asm"
.include "words/number.asm"
.include "words/interpret.asm"
.include "words/evaluate.asm"
.include "words/prompt-ok.asm"
.include "words/prompt-ready.asm"
.include "words/prompt-error.asm"
.include "words/refill.asm"
.include "words/quit.asm"
.include "words/abort.asm"
.include "words/q-abort.asm"
.include "words/abort-string.asm"
.include "words/tick.asm"
.include "words/char.asm"
.include "words/bracketchar.asm"
.include "words/l-paren.asm"

; COMPILER ======================================
.include "words/header.asm"
.include "words/builds.asm"
.include "words/create.asm"
.include "words/do-does.asm"
.include "words/does.asm"
.include "words/recurse.asm"
.include "words/left-bracket.asm"
.include "words/right-bracket.asm"
.include "words/hide.asm"
.include "words/reveal.asm"
.include "words/colon.asm"
.include "words/semicolon.asm"
.include "words/brackettick.asm"
.include "words/postpone.asm"

; EXCEPTIONS ======================
.include "words/catch.asm"
.include "words/handler.asm"
.include "words/throw.asm"

; CONTROL STRUCTURES ============================
.include "words/g-resolve.asm"
.include "words/g-mark.asm"
.include "words/l-resolve.asm"
.include "words/l-mark.asm"
.include "words/compile.asm"

.include "words/ahead.asm"
.include "words/if.asm"
.include "words/then.asm"
.include "words/else.asm"
.include "words/begin.asm"
.include "words/until.asm"
.include "words/again.asm"
.include "words/while.asm"
.include "words/repeat.asm"
.include "words/to-l.asm"
.include "words/l-from.asm"
.include "words/do.asm"
.include "words/qdo.asm"
.include "words/endloop.asm"
.include "words/loop.asm"
.include "words/plusloop.asm"
.include "words/leave.asm"


; OTHER OPERATIONS ==============================
.include "words/within.asm"
.include "words/depth.asm"

; UTILITY WORDS AND STARTUP =====================
.include "words/flaligned.asm"
.include "words/marker.asm"
.include "words/words.asm"
.include "words/traverse-wordlist.asm"
.include "words/name2string.asm"
.include "words/show-wordlist.asm"

.include "words/u-dot-r.asm"
.include "words/ud-dot.asm"
.include "words/ud-dot-r.asm"
.include "words/dot-r.asm"
.include "words/d-dot.asm"
.include "words/d-dot-r.asm"

.include "words/dot-s.asm"
.include "words/cold.asm"
.include "words/applturnkey.asm"
.include "words/environment.asm"
.include "words/env-cpu.asm"
.include "words/env-forthname.asm"
.include "words/env-forthversion.asm"
.include "words/ver.asm"
.include "words/f_cpu.asm"
.include "words/q-stack.asm"

; Note: the first character sent from the MSP430 seems to get
; scrambled.  I conjecture this is because the baud rate generator
; has not reset to the new rate when we attempt to send a character.
; See init430f1611.s43 for delay after initialization.

.include "words/backslash.asm"
.include "words/parse-name.asm"
.include "words/map-stack.asm"
.include "words/do-recognizer.asm"
.include "words/r-fail.asm"
.include "words/r-word.asm"
.include "words/r-intnumber.asm"

.include "words/scomma.asm"
.include "words/compare.asm"
.include "words/search-wordlist.asm"
.include "words/num-constants.asm"
