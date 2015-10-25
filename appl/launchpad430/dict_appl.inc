; These words not part of the essentials
; but written in assembly language / notoation

; simple stack dump
;.include "words/dot-s.asm"

; bleeding edge
;.include "words/build-info.asm"
;.include "words/git-info.asm"

; next some words that may be useful in certain
; applications only. Including them by default
; would make the image too large to fit into 8kB
; all other words are written in forth and have to
; be uploaded as such.

; location of some configuration stacks
;.include "words/cfg-order.asm"
;.include "words/cfg-recognizer.asm"


;; generic tools
;.include "words/get-stack.asm"
;.include "words/set-stack.asm"

;; wordlist management.
;.include "words/infodp.asm"
;.include "words/wordlist.asm"
;.include "words/set-order.asm"
;.include "words/get-order.asm"
;.include "words/set-current.asm"
;.include "words/forth-wordlist.asm"

;; double cell arithmetics
;.include "words/d-plus.asm"
;.include "words/d-minus.asm"

;; some (external) assembly required
;.include "words/code.asm"
;.include "words/end-code.asm"

;; compiler
;.include "words/bracketcompile.asm"

;; text interpreter
;.include "words/get-recognizer.asm"
;.include "words/set-recognizer.asm"
;.include "words/name2interpret.asm"
;.include "words/name2compile.asm"

;; legacy words
;.include "words/word.asm"
;.include "words/count.asm"

;; bit level operations
;.include "words/bm-set.asm"
;.include "words/bm-clear.asm"
;.include "words/bm-test.asm"
