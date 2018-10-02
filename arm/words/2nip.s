  CODEWORD Flag_visible, "2nip", 2NIP @ ( 4 3 2 1 -- 2 1 )
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
NEXT
