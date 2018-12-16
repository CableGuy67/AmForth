
CODEWORD  "up@", UP_FETCH
  savetos
  mov tos, up
NEXT

CODEWORD  "up!", UP_STORE
  mov up, tos
  loadtos
NEXT
