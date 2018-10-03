
@ Write and Erase Flash in LM4F120.

.equ FLASH_FMA, 0x400FD000
.equ FLASH_FMD, 0x400FD004
.equ FLASH_FMC, 0x400FD008

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "flash!", FLASH_STORE @ ( x Addr -- )
@ -----------------------------------------------------------------------------
  popda r0 @ Adresse
  popda r1 @ Inhalt.

  @ Prüfe Inhalt. Schreibe nur, wenn es NICHT -1 ist.
  cmp r1, #-1
  beq 2f

  @ Prüfe die Adresse: Sie muss auf 4 gerade sein:
  ands r2, r0, #3
  cmp r2, #0
  bne 2f

  @ Ist an der gewünschten Stelle -1 im Speicher ? Muss noch ersetzt werden durch eine Routine, die prüft, ob nur 1->0 Wechsel auftreten.
  ldr r2, [r0]
  cmp r2, #-1
  bne 2f

flashkomma_innen:

  @ Alles paletti. Schreibe tatsächlich !
  ldr r2, =FLASH_FMD @ 1. Write source data to the FMD register.
  str r1, [r2]

  ldr r2, =FLASH_FMA @ 2. Write the target address to the FMA register.
  str r0, [r2]

  ldr r2, =FLASH_FMC @ 3. Write the Flash memory write key and the WRITE bit (a value of 0xA442.0001) to the FMC register.
  ldr r3, =0xA4420001
  str r3, [r2]

1:ldr r3, [r2]       @ 4. Poll the FMC register until the WRITE bit is cleared.
  ands r3, #1
  cmp r3, #0
  bne 1b

2:NEXT

@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "hflash!", HFLASH_STORE @ ( x Addr -- )
  @ Schreibt an die auf 2 gerade Adresse in den Flash.
@ -----------------------------------------------------------------------------
  popda r0 @ Adresse
  popda r1 @ Inhalt.

  @ Prüfe Inhalt. Schreibe nur, wenn es NICHT -1 ist.
  ldr r3, =0xFFFF
  ands r1, r3  @ High-Halfword der Daten wegmaskieren
  cmp r1, r3
  beq 2b

  @ Prüfe die Adresse: Sie muss auf 2 gerade sein:
  ands r2, r0, #1
  cmp r2, #0
  bne 2b

  @ Ist an der gewünschten Stelle -1 im Speicher ? Muss noch ersetzt werden durch eine Routine, die prüft, ob nur 1->0 Wechsel auftreten.
  ldrh r2, [r0]
  cmp r2, r3
  bne 2b

h_flashkomma_innen:
  @ Alles okay, alle Proben bestanden. Kann beginnen, zu schreiben.
  @ Ist die Adresse auf 4 gerade ?
  ands r2, r0, #2
  cmp r2, #0
  beq.n hflash_gerade

  @ hflash! ungerade:
  @ Muss an der auf 4 geraden Adresse davor ein Word holen.
  subs r0, #2
  ldrh r2, [r0]
  lsls r1, #16  @ Die Daten hochschieben
  orrs r1, r2 @ Den Inhalt zu den gewünschten Daten hinzuverodern
  @ Fertig. Habe die Daten für den auf 4 geraden Zugriff fertig.
  b.n flashkomma_innen

  @ hflash! gerade:
hflash_gerade:
  adds r2, r0, #2
  ldrh r3, [r2]
  lsls r3, #16
  orrs r1, r3 @ Den Inhalt zu den gewünschten Daten hinzuverodern
  @ Fertig. Habe die Daten für den auf 4 geraden Zugriff fertig.
  b.n flashkomma_innen


 @ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "cflash!", CFLASH_STORE @ ( x Addr -- )
  @ Schreibt ein einzelnes Byte in den Flash.
@ -----------------------------------------------------------------------------
  popda r0 @ Adresse
  popda r1 @ Inhalt.

  @ Prüfe Inhalt. Schreibe nur, wenn es NICHT -1 ist.
  ands r1, #0xFF @ Alles Unwichtige von den Daten wegmaskieren
  cmp  r1, #0xFF
  beq 2b

  @ Ist an der gewünschten Stelle -1 im Speicher ? Muss noch ersetzt werden durch eine Routine, die prüft, ob nur 1->0 Wechsel auftreten.
  ldrb r2, [r0]
  cmp r2, #0xFF
  bne 2b

  @ Alles okay, alle Proben bestanden. Kann beginnen, zu schreiben.
  @ Ist die Adresse auf 2 gerade ?
  ands r2, r0, #1
  cmp r2, #0
  beq.n cflash_gerade

  @ cflash! ungerade:
  @ Muss an der geraden Adresse davor ein Word holen.
  subs r0, #1
  ldrb r2, [r0]
  lsls r1, #8  @ Die Daten hochschieben
  orrs r1, r2 @ Den Inhalt zu den gewünschten Daten hinzuverodern
  @ Fertig. Habe die Daten für den auf 4 geraden Zugriff fertig.
  b.n h_flashkomma_innen

  @ cflash! gerade:
cflash_gerade:
  adds r2, r0, #1
  ldrb r3, [r2]
  lsls r3, #8
  orrs r1, r3 @ Den Inhalt zu den gewünschten Daten hinzuverodern
  @ Fertig. Habe die Daten für den auf 4 geraden Zugriff fertig.
  b.n h_flashkomma_innen


@ -----------------------------------------------------------------------------
  CODEWORD Flag_visible, "flashpageerase", FLASHPAGEERASE @ ( Addr -- )
  @ Löscht einen 1kb großen Flashblock
@ -----------------------------------------------------------------------------
  push {r0, r1, r2, r3}
  popda r0 @ Adresse zum Löschen holen

  ldr r2, =FLASH_FMA @ 1. Write the page address to the FMA register.
  str r0, [r2]

  ldr r2, =FLASH_FMC @ 2. Write the Flash memory write key and the ERASE bit (a value of 0xA442.0002) to the FMC register.
  ldr r3, =0xA4420002
  str r3, [r2]

1:ldr r3, [r2]       @ 3. Poll the FMC register until the ERASE bit is cleared
  ands r3, #2
  cmp r3, #0
  bne 1b

  pop {r0, r1, r2, r3}
  NEXT
