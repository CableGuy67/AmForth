
.include "macros.s"

.include "preamble.inc"

STARTDICT

.include "dict_prims.inc"
.include "dict_drivers.inc"
.include "dict_secs.inc"
.include "dict_env.inc"


.equ HERESTART, rampointer
.equ DPSTART, dppointer
ENDDICT
