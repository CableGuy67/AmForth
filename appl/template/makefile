# --------------------------------------------------------- #

# --------- makefile to build project application --------- #

# ---------------- begin edit local values ---------------- #

# Your shell of choice
SHELL=/bin/bash

# Application name. Must match the project .asm file here.
# All files that are generated will use this name.
TARGET=template

# Point to the root of the AmForth repo
ROOT=../..
# Location of the Atmel include files
ATMEL_INC=$(ROOT)/avr8/devices/appnote_inc

# MCU should be identical to the device as listed in MCU/devices
MCU=YOUR_DEVICE

# Set the fuses according to your MCU
LFUSE=0xNN
HFUSE=0xNN
# some MCU have this one, see write-fuses target below
EFUSE=0xNN

# Assembler information
AVRA=$(ROOT)/avr8/tools/avra/src/avra
AVRASM=$(ROOT)/avr8/tools/avrasm/avrasm2.exe
# Uncomment if using avrasm2 with linux
# USING_WINE=wine

# Use this for avrasm2.exe with Windows or linux with wine
# ASSEMBLER=$(USING_WINE) $(AVRASM) -I $(ATMEL_INC)
# Use this to use avra 
ASSEMBLER=$(AVRA) -I $(ATMEL_INC)

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

erase:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -e

install: $(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -e -U flash:w:$(TARGET).hex:i -U eeprom:w:$(TARGET).eep.hex:i

$(TARGET).hex: $(TARGET).asm words/*.asm $(ROOT)/common/words/*.asm \
               $(ROOT)/avr8/words/*.asm $(ROOT)/avr8/devices/$(MCU)/*.asm
	cd $(ROOT)/avr8/tools/avra/; make; cd -;
	( TSTAMP=$$(date +"%Y-%m-%dT%H:%M:%S"); \
	TSTAMPLEN=$${#TSTAMP}; \
	echo "($$TSTAMPLEN) $$TSTAMP"; \
	sed -e "s/@TSTAMPLEN@/$$TSTAMPLEN/g" -e "s/@TSTAMP@/$$TSTAMP/g" \
	$(ROOT)/common/words/build-info.tmpl > words/build-info.asm )
	$(ASSEMBLER) $(INCLUDE) -fI -e $(TARGET).eep.hex -l $(TARGET).lst $(TARGET).asm

$(TARGET).back:
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -U flash:r:$(TARGET).backup.hex:i -U eeprom:r:$(TARGET).eep.backup.hex:i

clean:
	rm -f $(TARGET).hex
	rm -f $(TARGET).eep.hex
	rm -f $(TARGET).lst
	rm -f $(TARGET).map
	rm -f $(TARGET).cof
	rm -f $(TARGET).obj

read-fuse:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:r:-:h -U lfuse:r:-:h -U efuse:r:-:h -U lock:r:-:h

write-fuse:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m -U efuse:w:$(EFUSE):m
