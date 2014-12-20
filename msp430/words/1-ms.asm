;  xx 0 DO yy 0 DO LOOP LOOP ;  adjust xx and yy to get a msec.
     HEADER(XT_1MS,3,"1ms",DOCOLON)
         DW XT_DOLITERAL,41,XT_ZERO,XT_DODO
onems1:  DW XT_DOLITERAL,11,XT_ZERO,XT_DODO
onems2:  DW XT_DOLOOP
         DEST(onems2)
         DW XT_DOLOOP
         DEST(onems1)
         DW XT_EXIT
