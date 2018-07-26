
CODEWORD Flag_visible, "up@", UP_FETCH
    savetos
    mv x3, x19
    NEXT

CODEWORD Flag_visible, "up!", UP_STORE
    mv x19,x3
    loadtos
    NEXT

