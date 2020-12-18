# 2020-12-02 amforth/erwaelde
# ./test/firmware/avr8-at644p/Makefile

SHELL=/bin/bash

AMFORTH=../../..
MCU=atmega644p

# external quarz at 11.0592 MHz
# 644p
LFUSE=0xe6
HFUSE=0x99
EFUSE=0xff

# --- programmer hardware
# DRAGON=-c dragon_isp -P usb
MKII:=-c avrispmkII -P usb

PROGRAMMER=$(MKII)

# --- programmer software
AVRDUDE=sudo avrdude
AVRDUDE_FLAGS=-q $(PROGRAMMER) -p $(MCU)

# --- serial connection
CONSOLE=/dev/ttyUSB0


DIR_ATMEL=../../../avr8/Atmel


ASM=wine $(DIR_ATMEL)/avrasm2.exe
ASM_FLAGS=-fI -v0 -I $(DIR_ATMEL)/Appnotes

INCLUDE=-I $(AMFORTH)/avr8/devices/$(MCU) -I $(AMFORTH)/avr8 -I $(AMFORTH)/common


all: firmware

firmware: testfirmware.hex

erase:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -e

upload-tester:
	@echo "CONSOLE=$(CONSOLE)"
	cat testfirmware.fs | fs.unfold | fs.del_require > testfirmware.fs.unfold
	fs.trim testfirmware.fs.unfold  > testfirmware.fs.upload
	amforth-upload.py  -t ${CONSOLE} testfirmware.fs.upload

firmware-install: testfirmware.hex
	@echo "AVRDUDE=$(AVRDUDE)"
	@echo "AVRDUDE_FLAGS=$(AVRDUDE_FLAGS)"
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -e -U flash:w:testfirmware.hex:i -U eeprom:w:testfirmware.eep.hex:i

testfirmware.hex: testfirmware.asm words/*.asm $(AMFORTH)/common/words/*.asm $(AMFORTH)/avr8/words/*.asm $(AMFORTH)/avr8/devices/$(MCU)/*.asm
	( TSTAMP=$$(date +"%Y-%m-%dT%H:%M:%S"); \
         TSTAMPLEN=$${#TSTAMP}; \
         echo "($$TSTAMPLEN) $$TSTAMP"; \
         sed -e "s/@TSTAMPLEN@/$$TSTAMPLEN/g" -e "s/@TSTAMP@/$$TSTAMP/g" $(AMFORTH)/common/words/build-info.tmpl > words/build-info.asm )
	$(ASM) $(ASM_FLAGS) $(INCLUDE) -e testfirmware.eep.hex -l testfirmware.lst -m testfirmware.map testfirmware.asm

testfirmware.back:
	$(AVRDUDE) $(AVRDUDE_FLAGS)  -U flash:r:testfirmware.hex:i -U eeprom:r:testfirmware.eep.hex:i

clean:
	rm -f *.{hex,eep.hex,lst,map,cof,obj,fs.upload,fs.unfold}

write-fuse:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m

read-fuse:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U hfuse:r:-:h -U lfuse:r:-:h -U efuse:r:-:h -U lock:r:-:h
