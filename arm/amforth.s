
.include "macros.s"

.include "preamble.inc"
.include "user.inc"
.include "common/vectors.s" 
.include "common/isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

.include "dict_appl.inc"

ENDDICT
