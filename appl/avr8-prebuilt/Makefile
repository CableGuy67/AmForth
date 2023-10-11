# Simple makefile for building the 
# Arduino amforth vor various targets

# ======================================================================
# SHELL CONFIGURATION

SHELL=/bin/bash

# ======================================================================
# ASSEMBLER CONFIGURATION

# Set to 'yes' if you want to use avra or leave empty for avrasm2.
# If avra binary does not exist it will be built before any hex files
USE_AVRA=yes
# Set to 'wine' if using avrasm2 with linux under wine or leave empty
# if using avrasm2 under windows.
USE_WINE=

ALL=uno.hex atmega2560.hex

# ======================================================================
# PROGRAMMER CONFIGURATION

# avrdude programmer name
#PROGRAMMER=stk500
# -P port-name *OR* leave empty 
#PROGPORT=-P /dev/cu.usbmodem002492272

# some alternative configurations 
PROGRAMMER=usbtiny
PROGPORT=

# ======================================================================
# AVRDUDE CONFIGURATION

# avrdude executable 
#AVRDUDE=/usr/local/bin/avrdude
AVRDUDE=avrdude

# -C path *OR* leave empty 
#AVRCONF=-C ./avrdude.conf              

AVRDUDE_FLAGS= $(PROGPORT) -c $(PROGRAMMER) $(AVRCONF)
AVRVER:=$(shell $(AVRDUDE) 2>&1 | sed -n /version/p)

#AVRDUDE=/Users/tw/Downloads/avrdude-main/build_darwin/src/avrdude
#AVRDUDE=/Users/tw/Downloads/avrdude-7.1/build_darwin/src/avrdude
#AVRDUDE=/Users/tw/Downloads/avrdude-6.3/avrdude

#AVRDUDE_FLAGS=-q -P $(PORT) -c $(PROGRAMMER)
#AVRDUDE_FLAGS= $(PORT) -c $(PROGRAMMER) -C ./avrdude.conf
#AVRDUDE_FLAGS= $(PROGPORT) -c $(PROGRAMMER) -C 

# ======================================================================
# TERMINAL CONFIGURATION

TERMINAL=minicom
MODEM=/dev/tty.usbmodem14501
TERMINAL_FLAGS=-D $(MODEM) -b 38400

# ======================================================================
# amforth-shell.py CONFIGURATION

AMSHELL=$(ROOT)/tools/amforth-shell.py --port $(MODEM) --speed 38400 $1

# ======================================================================

# ======================================================================

help:
	@echo ""
	@echo "This makefile builds the prebuilt hex files for all (or selected) boards/mcu."
	@echo "In addition, a single board/mcu's flash/eeprom can be flashed/stored/erased,"  
	@echo "and various post build activities involked. "
	@echo ""
	@echo "make             - display this help"
	@echo "make help        - display this help"
	@echo "make all         - make everything for $(ALL)"
	@echo "make device.hex  - make hex files for this device (only)"
	@echo "make device.bak  - save current flash/eeprom to file"
	@echo "make device.era  - erase current flash/eeprom"
	@echo "make device.fuse - set fuses of device (as per Makefile values)"
	@echo "make device      - flash device.hex and device.ee.hex to current mcu"
	@echo "make clean       - remove all .hex .lst .obj .cof and .map files"
	@echo "make term        - connect to serial port via terminal"
	@echo "make shell       - connect to serial port via amforth-shell.py #exit to leave"
	@echo "make test        - connect via shell and run tests contained in tests.forth"
	@echo ""
	@echo "ASSEMBLER        - $(ASMEX)"
	@echo "PROGRAMMER       - $(PROGRAMMER)"
	@echo "AVRDUDE          - $(AVRDUDE) $(AVRDUDE_FLAGS)"
	@echo "AVRDUDE VERSION  - $(AVRVER)"
	@echo "MODEM            - $(MODEM)"	
	@echo "TERMINAL         - $(TERMINAL) $(TERMINAL_FLAGS)"
	@echo ""


term:
	$(TERMINAL) $(TERMINAL_FLAGS)


shell:
	$(AMSHELL)

test:
	@echo "This will take a considerable time. Output captured in tests.log"
	$(AMSHELL) --no-error-on-output tests.forth | tee tests.log 

# ======================================================================
# SET THE MCU SPECIFIC  

uno:              PART=m328p
uno.hex:          MCU=atmega328p
uno.era:          PART=m328p
uno.bak:          PART=m328p
uno.fuse:         PART=m328p
uno.fuse:         LFUSE=0xFF
uno.fuse:         HFUSE=0xD9
uno.fuse:         EFUSE=0x05
uno.info:	  PART=m328p

atmega2560:        PART=m2560
atmega2560.hex:    MCU=atmega2560
atmega2560.era:    PART=m2560
atmega2560.bak:    PART=m2560
atmega2560.fuse:   PART=m2560
atmega2560.fuse:   LFUSE=0xFF
atmega2560.fuse:   HFUSE=0xD9
atmega2560.fuse:   EFUSE=0xF7
atmega2560.info:   PART=m2560

# ======================================================================
# DECIDE WHICH ASSEMBLER TO USE

ROOT=../..

AVRA=$(ROOT)/avr8/tools/avra/src/avra
AVRASM=$(ROOT)/avr8/tools/avrasm/avrasm2.exe
CORE=$(ROOT)/avr8
ATMEL_INC=$(CORE)/devices/appnote_inc

ifeq ($(USE_AVRA),yes)
	ASMEX=$(AVRA)
        ASM=$(ASMEX) -I $(ATMEL_INC)
else
	ASMEX=$(USE_WINE) $(AVRASM)
        ASM=$(ASMEX) -I $(ATMEL_INC)
endif

AS_INCLUDE=-I $(CORE) -I $(CORE)/devices -I $(ROOT)/common
AS_FLAGS=$(AS_INCLUDE) -fI

#--------------------------
# Generic assemble patterns
#--------------------------

# Assemble the target
%.hex : %.asm
	@echo "Producing Hexfiles for Arduino $*" 

ifeq ($(USE_AVRA),yes)
ifeq ($(AVRA),$(wildcard $(AVRA)))
	@echo "avra built already..."
else
	cd $(ROOT)/avr8/tools/avra/; make;
endif
endif

	( TSTAMP=$$(date +"PREBUILT %Y-%m-%dT%H:%M:%S"); \
	TSTAMPLEN=$${#TSTAMP}; \
	echo "($$TSTAMPLEN) $$TSTAMP"; \
	sed -e "s/@TSTAMPLEN@/$$TSTAMPLEN/g" -e "s/@TSTAMP@/$$TSTAMP/g" \
	$(ROOT)/common/words/build-info.tmpl > words/build-info.asm )

	@$(ASM) $(AS_FLAGS) -I $(CORE)/devices/$(MCU) -e $*.eep.hex -m $*.map -l $*.lst $<

# Flash the target
% : %.hex
	@echo "Uploading Hexfiles to Arduino $*" 
	$(AVRDUDE) $(AVRDUDE_FLAGS) -p $(PART) -e -U flash:w:$*.hex:i -U eeprom:w:$*.eep.hex:i

# Set the fuse bits
%.fuse :
	@echo "Setting fuses to Arduino $*" 
	$(AVRDUDE) $(AVRDUDE_FLAGS) -p $(PART) -U efuse:w:$(EFUSE):m -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m

# Erase the whole MCU
%.era :
	@echo "Erasing entire Arduino $*" 
	$(AVRDUDE) $(AVRDUDE_FLAGS) -p $(PART) -e

# MCU info 
%.info :
	@echo "Info $*" 
	$(AVRDUDE) $(AVRDUDE_FLAGS) -p $(PART) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h

# Clear assembled & auxilars files
%.clr:
	@echo "Cleaning all aux files" 
	@rm -f $*.hex ; rm -f $*.eep.hex ; rm -f $*.lst ; rm -f $*.map ; rm -f $*.cof ; rm -f $*.obj

# Backup arduino Flash & EEPROM files
%.bak:
	@echo "Backup Flash & EEPRON from Arduino $*" 
	$(AVRDUDE) $(AVRDUDE_FLAGS) -p $(PART) -U flash:r:$*.hex.bak:i -U eeprom:r:$*.eep.hex.bak:i

# ----------------------------------------------------------

GENERIC_DEPENDECIES=*.inc words/*.asm $(CORE)/*.asm $(CORE)/words/*.asm $(CORE)/drivers/*.asm

all: $(ALL)

$(ALL) :  $(GENERIC_DEPENDENCIES)  $(CORE)/devices/*/*.asm $(CORE)/devices/*/*.inc


# ======================================================================
# Cleans everything

clean:
	rm -f *.hex ; rm -f *.eep.hex ; rm -f *.lst ; rm -f *.map ; rm -f *.cof ; rm -f *.obj


