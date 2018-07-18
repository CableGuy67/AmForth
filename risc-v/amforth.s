
.include "macros.s"

.include "preamble.inc"

DOCOLON: 
        push x16   # IP
        mv x16,x17  # W->IP
DO_NEXT:
        lw x17, 0(x16) # @IP -> W 
        addi x16,x16,4 # INC IP
DO_EXECUTE:
        lw x18, 0(x17) # @W, address of some executable code
        addi x17,x17,4 # INC W, points now to PFA
        jalr zero,x18,0 # jump to code

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_drivers.inc"

# Finalize the dictionary structure and put a pointer into changeable Flash-Dictionary
# -----------------------------------------------------------------------------

  Definition_EndOfCore Flag_invisible, "--- Flash Dictionary ---"

# -----------------------------------------------------------------------------
#  End of Dictionary
# -----------------------------------------------------------------------------

