
CODEWORD Flag_visible, "up@", UP_FETCH
  savetos
  mov tos, up
NEXT

CODEWORD Flag_visible, "up!", UP_STORE
  mov up, tos
  loadtos
NEXT
