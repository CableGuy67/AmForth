#
# all primitves / code words
# they are placed close together to
# maximize cache usage
#

.include "common/forth-core.s"

.include "words/cold.s"

.include "words/exit.s"

.include "words/drop.s"
.include "words/swap.s"
.include "words/dup.s"
.include "words/nip.s"
.include "words/over.s"
.include "words/rot.s"
.include "words/q-dup.s"
.include "words/tuck.s"
.include "words/m-rot.s"
.include "words/pick.s"

.include "words/to-r.s"
.include "words/r-from.s"
.include "words/r-fetch.s"
.include "words/rp-fetch.s"
.include "words/rp-store.s"
.include "words/sp-fetch.s"
.include "words/sp-store.s"

.include "words/fetch.s"
.include "words/store.s"
