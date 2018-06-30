
.include "macros.s"

DOCOLON: 
        push x6   # IP
        mv x5,x6  # W->IP
DO_NEXT:
        lw x5, 0(x6) # @IP -> W 
        addi x6,x6,4 # INC IP
DO_EXECUTE:
        lw x7, 0(x5) # @W, address of some executable code
        addi x5,x5,4 # INC W, points now to PFA
        jalr x0,x7,0 # jump to code
#        jr   x0,x7

.include "dict_prims.inc"

.include "dict_secs.inc"

.include "dict_drivers.inc"

# Finalize the dictionary structure and put a pointer into changeable Flash-Dictionary
# -----------------------------------------------------------------------------

  Definition_EndOfCore Flag_invisible, "--- Flash Dictionary ---"

# -----------------------------------------------------------------------------
#  End of Dictionary
# -----------------------------------------------------------------------------

