# --------------------------------------------------------- #

# --------- makefile to build project application --------- #

# ---------------- begin edit local values ---------------- #

# Your shell of choice
SHELL=/bin/bash

# Application name. Must match the project .asm file here.
# All files that are generated will use this name.
TARGET=app_name

# CONDITIONALS
# Set to 'yes' if you want to build avra. After the first build this can
# be left blank and avra will not rebuild or clean it.
MAKE_AVRA=yes
# Set to 'yes' if you want to use avra or leave empty for avrasm2.
USE_AVRA=yes
# Set to 'wine' if using avrasm2 with linux under wine or leave empty
# if using avrasm2 under windows.
USE_WINE=
# Set to 'yes' if your MCU has an EFUSE or empty if no EFUSE.
HAVE_EFUSE=yes

# Point to the root of the AmForth repo
ROOT=../..
# Location of the Atmel include files
ATMEL_INC=$(ROOT)/avr8/devices/appnote_inc

# MCU should be identical to the device as listed in MCU/devices
MCU=YOUR_MCU_NAME

# Set the fuses according to your MCU
LFUSE=0xNN
HFUSE=0xNN
# some MCU have this one, leave blank if MCU does not have one
EFUSE=0xNN

# Assembler information
AVRA=$(ROOT)/avr8/tools/avra/src/avra
AVRASM=$(ROOT)/avr8/tools/avrasm/avrasm2.exe

ifeq ($(USE_AVRA),yes)
        ASSEMBLER= $(AVRA) -I $(ATMEL_INC)
else
        ASSEMBLER=$(USE_WINE) $(AVRASM) -I $(ATMEL_INC)
endif

# Programmer information
# change PROGRAMMER, BAUD_RATE, PORT and AVRDUDE as needed
PROGRAMMER=usbasp
BAUD_RATE=19200
PORT=/dev/ttyUSB0
PROGRAMMER_FLAGS=-c $(PROGRAMMER) -b $(BAUD_RATE) -P $(PORT)
AVRDUDE=avrdude
AVRDUDE_FLAGS=$(PROGRAMMER_FLAGS) -p $(MCU)

# ----------------- end edit local values ----------------- #

INCLUDE=-I $(ROOT)/avr8/devices/$(MCU) -I $(ROOT)/avr8 -I $(ROOT)/common

default:  $(TARGET).hex

install: $(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -e -U flash:w:$(TARGET).hex:i -U eeprom:w:$(TARGET).eep.hex:i

$(TARGET).hex: $(TARGET).asm words/*.asm $(ROOT)/common/words/*.asm \
               $(ROOT)/avr8/words/*.asm $(ROOT)/avr8/devices/$(MCU)/*.asm

        ifeq ($(MAKE_AVRA),yes)
	    cd $(ROOT)/avr8/tools/avra/; make;
        endif

	( TSTAMP=$$(date +"%Y-%m-%dT%H:%M:%S"); \
	TSTAMPLEN=$${#TSTAMP}; \
	echo "($$TSTAMPLEN) $$TSTAMP"; \
	sed -e "s/@TSTAMPLEN@/$$TSTAMPLEN/g" -e "s/@TSTAMP@/$$TSTAMP/g" \
	$(ROOT)/common/words/build-info.tmpl > words/build-info.asm )
	$(ASSEMBLER) $(INCLUDE) -fI -e $(TARGET).eep.hex -l $(TARGET).lst $(TARGET).asm

.PHONEY: clean read-fuse write-fuse erase backup
clean:
	rm -f $(TARGET).hex
	rm -f $(TARGET).eep.hex
	rm -f $(TARGET).lst
	rm -f $(TARGET).map
	rm -f $(TARGET).cof
	rm -f $(TARGET).obj

        ifeq ($(MAKE_AVRA),yes)
	    cd $(ROOT)/avr8/tools/avra/; make clean;
        endif

erase:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -e

backup:
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -U flash:r:$(TARGET).backup.hex:i -U eeprom:r:$(TARGET).eep.backup.hex:i

read-fuse:
        ifeq ($(HAVE_EFUSE),yes)
	    $(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:r:-:h -U lfuse:r:-:h -U efuse:r:-:h -U lock:r:-:h
        else
	    $(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:r:-:h -U lfuse:r:-:h -U lock:r:-:h
        endif

write-fuse:
        ifeq ($(HAVE_EFUSE),yes)
	    $(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m -U efuse:w:$(EFUSE):m
        else
	    $(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m
        endif
