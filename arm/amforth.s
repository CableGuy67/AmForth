
.include "macros.s"

.include "preamble.inc"
.include "user.inc"
.include "common/vectors.s" 

STARTDICT

.include "dict_prims.inc"
.include "dict_drivers.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

ENDDICT