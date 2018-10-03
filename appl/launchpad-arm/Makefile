
CPU ?= cortex-m0

REVISION := $(shell git log -1 --abbrev=8 --pretty=format:%h)

BOARD = lp-stellaris
LANG=C
%.lst: %.elf
	arm-none-eabi-objdump -D $< >$@

%.hex: %.elf
	arm-none-eabi-objcopy -O ihex $< $@

%.o: %.asm buildinfo
	arm-none-eabi-as --warn --fatal-warnings -alms=lp-stellaris.list -I../../arm -I ../../arm/devices/lm4f120xl -I ../../shared -o $@ $<

all: lp-stellaris.hex lp-stellaris.lst

lp-stellaris.elf: lp-stellaris.o ../../arm/amforth.s buildinfo
	arm-none-eabi-ld -T memmap $< -o $@ 
	arm-none-eabi-objcopy lp-stellaris.elf lp-stellaris.bin -O binary
	arm-none-eabi-objcopy lp-stellaris.elf lp-stellaris.hex -O ihex

clean:
	rm -f *.elf *.bin *.o *.log *.lst *.hex *.list

upload: lp-stellaris.elf
	lm4flash lp-stellaris.bin

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s
