
CODEWORD "cold", COLD

   ldr r0, =RAM_upper_returnstack
   mov sp, r0

   ldr psp, =RAM_upper_datastack

   ldr FORTHW, =XT_WARM

  b DO_EXECUTE
