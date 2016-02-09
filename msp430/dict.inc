
.include "words/execute.asm"
.include "words/lit.asm"
.include "words/exit.asm"

.include "words/variable.asm"
.include "words/constant.asm"
.include "words/user.asm"
.include "words/do-variable.asm"
.include "words/do-constant.asm"

; ----------------------------------------------------------------------
; COMPARISON OPERATIONS 

.include "words/zero-equal.asm"
.include "words/zero-less.asm"
.include "words/equal.asm"
.include "words/not-equal.asm"
.include "words/less.asm"
.include "words/greater.asm"
.include "words/u-less.asm"
.include "words/u-greater.asm"

; ----------------------------------------------------------------------
; STACK OPERATIONS

.include "words/dup.asm"
.include "words/qdup.asm"
.include "words/drop.asm"
.include "words/swap.asm"
.include "words/over.asm"
.include "words/rot.asm"
.include "words/nip.asm"
.include "words/tuck.asm"

.include "words/to-r.asm"
.include "words/r-from.asm"
.include "words/r-fetch.asm"
.include "words/2-to-r.asm"
.include "words/2-r-from.asm"

.include "words/sp-fetch.asm"
.include "words/sp-store.asm"
.include "words/rp-fetch.asm"
.include "words/rp-store.asm"


; ----------------------------------------------------------------------
; MEMORY OPERATIONS

.include "words/fetch.asm"
.include "words/store.asm"
.include "words/c-fetch.asm"
.include "words/c-store.asm"


; ----------------------------------------------------------------------
; ARITHMETIC OPERATIONS

.include "words/plus.asm"
.include "words/plus-store.asm"
.include "words/m-plus.asm"
.include "words/minus.asm"
.include "words/and.asm"
.include "words/or.asm"
.include "words/xor.asm"
.include "words/invert.asm"
.include "words/negate.asm"
.include "words/1-plus.asm"
.include "words/1-minus.asm"
.include "words/byte-swap.asm"
.include "words/2-star.asm"
.include "words/2-slash.asm"
.include "words/lshift.asm"
.include "words/rshift.asm"


; ----------------------------------------------------------------------
; LOOP AND BRANCH OPERATIONS 

.include "words/branch.asm"
.include "words/q-branch.asm"
.include "words/do-do.asm"
.include "words/do-loop.asm"
.include "words/do-plusloop.asm"
.include "words/i.asm"
.include "words/j.asm"
.include "words/unloop.asm"

; ----------------------------------------------------------------------
; MULTIPLY AND DIVIDE

.include "words/um-star.asm"
.include "words/um-slash-mod.asm"

; ----------------------------------------------------------------------
; BLOCK AND STRING OPERATIONS

.include "words/fill.asm"
.include "words/cmove.asm"
.include "words/cmove-up.asm"
.include "words/cskip.asm"
.include "words/cscan.asm"
.include "words/s-equal.asm"

; ----------------------------------------------------------------------
; ALIGNMENT AND PORTABILITY OPERATORS 
.include "words/align.asm"
.include "words/aligned.asm"
.include "words/cellplus.asm"
.include "words/cells.asm"
.include "words/to-body.asm"
.include "words/up.asm"
; ----------------------------------------------------------------------

; most highlevel words for the core system.

; INPUT/OUTPUT ==================================
.include "words/cr.asm"
.include "words/space.asm"
.include "words/spaces.asm"
.include "words/umin.asm"
.include "words/umax.asm"
.include "words/accept.asm"
.include "words/type.asm"

; SYSTEM VARIABLES & CONSTANTS ==================

.include "words/a-to-info.asm"
.include "words/to-in.asm"
.include "words/base.asm"
.include "words/state.asm"
.include "words/dp.asm"
.include "words/get-current.asm"
.include "words/hld.asm"
.include "words/lp.asm"
.include "words/idp.asm"
.include "words/newest.asm"
.include "words/latest.asm"
.include "words/allot.asm"

.include "words/pad.asm"
.include "words/l-0.asm"
.include "words/rp0.asm"
.include "words/sp0.asm"
.include "words/sp.asm"
.include "words/tib.asm"
.include "words/bl.asm"
.include "words/to-upper.asm"
.include "words/uinit.asm"

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
.include "words/2drop.asm"
.include "words/2dup.asm"
.include "words/2swap.asm"


; HARVARD MODEL EXTENSIONS (split Code & Data)
.include "words/icount.asm"
.include "words/itype.asm"
.include "words/do-squote.asm"
.include "words/squote.asm"
.include "words/dot-quote.asm"
.include "words/sliteral.asm"
.include "words/2literal.asm"
.include "words/i-fetch.asm"
.include "words/ic-fetch.asm"

; NUMERIC OUTPUT ================================
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
.include "words/i-here.asm"
.include "words/i-allot.asm"

; INTERPRETER ===================================
.include "words/source.asm"
.include "words/slash-string.asm"
.include "words/parse.asm"
.include "words/nfa-to-lfa.asm"
.include "words/nfa-to-cfa.asm"
.include "words/name2flags.asm"
.include "words/immediate-q.asm"
.include "words/find-xt.asm"
.include "words/literal.asm"
.include "words/digit-q.asm"
.include "words/q-sign.asm"
.include "words/set-base.asm"
.include "words/to-number.asm"
.include "words/number.asm"
.include "words/interpret.asm"
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
.include "words/create.asm"
.include "words/do-create.asm"
.include "words/wlscope.asm"
.include "words/do-does.asm"
.include "words/does.asm"
.include "words/recurse.asm"
.include "words/left-bracket.asm"
.include "words/right-bracket.asm"
.include "words/reveal.asm"
.include "words/colon.asm"
.include "words/colon-noname.asm"
.include "words/semicolon.asm"
.include "words/brackettick.asm"
.include "words/postpone.asm"
.include "words/i-cellplus.asm"
.include "words/immediate.asm"

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
.include "words/cold.asm"
.include "words/pause.asm"
.include "words/warm.asm"
.include "words/applturnkey.asm"  ; from application!
.include "words/environment.asm"
.include "words/env-cpu.asm"
.include "words/env-forthname.asm"
.include "words/env-forthversion.asm"
.include "words/ver.asm"
.include "words/f_cpu.asm"
.include "words/q-stack.asm"

.include "words/backslash.asm"
.include "words/parse-name.asm"
.include "words/map-stack.asm"
.include "words/forth-recognizer.asm"
.include "words/do-recognizer.asm"
.include "words/r-fail.asm"
.include "words/r-word.asm"
.include "words/r-intnumber.asm"

.include "words/scomma.asm"
.include "words/compare.asm"
.include "words/search-wordlist.asm"
.include "words/num-constants.asm"

.include "words/do-defer.asm"
.include "words/do-value.asm"
.include "words/turnkey.asm"
.include "words/to.asm"
.include "words/defer-fetch.asm"
.include "words/defer-store.asm"
.include "words/noop.asm"
.include "words/rdefer-fetch.asm"
.include "words/rdefer-store.asm"
.include "words/udefer-fetch.asm"
.include "words/udefer-store.asm"
.include "words/emit.asm"
.include "words/emitq.asm"
.include "words/key.asm"
.include "words/keyq.asm"
