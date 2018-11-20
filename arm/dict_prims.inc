#
# all primitves / code words
# they are placed close together to
# maximize cache usage
#

.include "words/exit.s"
.include "words/drop.s"
.include "words/swap.s"
.include "words/dup.s"
.include "words/nip.s"
.include "words/over.s"
.include "words/rot.s"
.include "words/q-dup.s"
.include "words/tuck.s"
.include "words/pick.s"

.include "words/to-r.s"
.include "words/r-from.s"
.include "words/r-fetch.s"
.include "words/rp.s"
.include "words/sp.s"

.include "words/fetch.s"
.include "words/store.s"

.include "words/negate.s"
.include "words/multiplydivide.s"
.include "words/stack.s"
.include "words/logic.s"
.include "words/memory.s"

.include "words/comparisions.s"


.include "words/2swap.s"
.include "words/2nip.s"
.include "words/2drop.s"
.include "words/2over.s"
.include "words/2r-fetch.s"
.include "words/2to-r.s"
.include "words/2r-from.s"


.include "words/2-slash.s"
.include "words/2-star.s"
.include "words/d-2star.s"
.include "words/d-2slash.s"
.include "words/dabs.s"
.include "words/dnegate.s"

DOCOLON: 
        push {FORTHIP}
        mov FORTHIP, FORTHW
DO_NEXT:
        ldr FORTHW, [FORTHIP], #4
DO_EXECUTE:
        ldr r0, [FORTHW], #4
        adds r0,#1
        mov pc, r0

.include "words/d-plus.s"
.include "words/d-minus.s"
.include "words/2dup.s"
.include "words/double.s"
.include "words/base.s"
.include "words/plus.s"
.include "words/minus.s"
.include "words/1-plus.s"
.include "words/1-minus.s"
.include "words/2-plus.s"
.include "words/2-minus.s"
.include "words/cell-plus.s"
.include "words/cells.s"

.include "words/state.s"
.include "words/tib.s"
.include "words/cold.s"
.include "words/quit.s"
.include "words/execute.s"

.include "words/key.s"
.include "words/keyq.s"
.include "words/emit.s"
.include "words/emitq.s"
.include "words/pause.s"
.include "words/nop.s"
.include "words/bounds.s"

.include "words/do-do.s"
.include "words/do-loop.s"
.include "words/unloop.s"
.include "words/i.s"
.include "words/j.s"

.include "words/aligned.s"
.include "words/do-sliteral.s"
.include "words/do-variable.s"
.include "words/do-data.s"
.include "words/do-value.s"
.include "words/do-defer.s"
.include "words/do-user.s"
.include "words/do-does.s"
.include "words/up.s"

.include "words/1ms.s"
.include "words/dobranch.s"
.include "words/docondbranch.s"
.include "words/doliteral.s"
.include "words/compare.s"
.include "words/num-constants.s"
.include "words/n_to_r.s"
.include "words/n_r_from.s"
