# git status may display remote/branch names. That disturbs sed later on
REVISION := $(shell git status -bs -u no|tr / -)
ifeq ("$(REVISION)", "")
    REVISION := $(shell svnversion -n)
endif

CROSS=arm-linux-gnueabi-
QEMU=qemu-arm-static
BOARD=$(shell uname -m)
ifeq ("$(BOARD)", "armv7l")
   CROSS=
   QEMU=
endif
LANG=C


%.o: %.asm buildinfo
	$(CROSS)as --warn -al=amforth.list -I ../../arm -I ../../arm/devices/linux -I ../../shared -o $@ $<

all: amforth

amforth: amforth.o
	$(CROSS)ld -T memmap -z max-page-size=4096 $< -o $@ 

clean:
	rm -f amforth *.elf *.bin *.o *.log *.lst *.hex *.list words/build-info.s

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s

# setup some terminal settings. Otherwise all input will be echo'ed
run: amforth
	stty -icanon -echo
	$(QEMU) ./amforth || true
	stty sane