# -----------------------------------------------------------------------------
# Memory map for Flash and RAM
# -----------------------------------------------------------------------------

.equ RamStart, 0x80000000 # Start of RAM          Porting: Change this !
.equ RamEnd,   0x80004000 # End   of RAM.  16 kb. Porting: Change this !

.equ FlashStart, 0x20400000 # Start of Flash          Porting: Change this !
.equ FlashEnd,   0x20410000 # End   of Flash.  64 kb. Porting: Change this !

.equ Kernschutzadresse,     FlashStart + 0x6000 # 24 kb reserved for core.
.equ FlashDictionaryAnfang, FlashStart + 0x6000 # 24 kb reserved for core.
.equ FlashDictionaryEnde,   FlashEnd

# -----------------------------------------------------------------------------
# Core start
# -----------------------------------------------------------------------------

.text
  j PFA_COLD

.include "amforth.s"
