nullhandler:
   push {lr}
   mrs r1, ipsr

   ldr r1, =#48 @ 0
   SEMIT r1

   adds r1, #48 @ "0"
   SEMIT r1


   pop {pc}

faulthandler:
   push {lr}

   mrs r1, ipsr

   ldr r1, =#70 @ F
   SEMIT r1

   adds r1, #48 @ "0"
   SEMIT r1


   pop {pc}

.ltorg
