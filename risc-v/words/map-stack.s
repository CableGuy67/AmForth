
COLON Flag_visible, "map-stack", MAPSTACK
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_SWAP
    .word XT_FETCH
    .word XT_CELLS
    .word XT_BOUNDS
    .word XT_QDOCHECK
    .word XT_DOCONDBRANCH,PFA_MAPSTACK3
    .word XT_DODO,PFA_MAPSTACK3
PFA_MAPSTACK1:
      .word XT_I
      .word XT_FETCH
      .word XT_SWAP
      .word XT_TO_R
      .word XT_R_FETCH
      .word XT_EXECUTE
      .word XT_QDUP
      .word XT_DOCONDBRANCH,PFA_MAPSTACK2
         .word XT_R_FROM
         .word XT_DROP
         .word XT_UNLOOP
         .word XT_EXIT
PFA_MAPSTACK2:
      .word XT_R_FROM
      .word XT_DOLITERAL,4
      .word XT_DOPLUSLOOP,PFA_MAPSTACK1
PFA_MAPSTACK3:
    .word XT_DROP
    .word XT_ZERO
    .word XT_EXIT
