nullhandler:
   push {lr}
   push {r1}
   ldr r1, =#48
   SEMIT r1
   mrs r1, ipsr
   add r1, #48 @ +"0"
   SEMIT r1

   pop {r1}
   pop {pc}

faulthandler:
   push {lr}
   push {r1}

   ldr r1, =#70 @ F
   SEMIT r1
   mrs r1, ipsr
   adds r1, #48 @ +"0"
   SEMIT r1
   pop {r1}
   pop {pc}

.ltorg
