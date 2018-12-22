
REVISION := $(shell git status -bs -u no)
ifeq ("$(REVISION)", "")
    REVISION := $(shell svnversion -n)
endif

BOARD = linux
LANG=C

%.o: %.asm
	arm-linux-gnueabi-as --warn -al=amforth.list -I ../../arm -I ../../arm/devices/linux -I ../../shared -o $@ $<

all: amforth

amforth: amforth.o
	arm-linux-gnueabi-ld -T memmap -z max-page-size=4096 $< -o $@ 

clean:
	rm -f amforth *.elf *.bin *.o *.log *.lst *.hex *.list words/build-info.s

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s

run: amforth
	qemu-arm-static amforth
