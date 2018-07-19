
PROGRAM_DIR=.
# PROGRAM ?= demo_gpio
# PROGRAM ?= led_fade
PROGRAM ?= hifive1.hex
BOARD ?= freedom-e300-hifive1

LINK_TARGET ?= flash

#########################
# location of binaries 
#########################
RISCV_GDB     = riscv64-unknown-elf-gdb
RISCV_OPENOCD = openocd
RISCV_TOOLS   = riscv64-unknown-elf

COPS = -Wall  -Os -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS = --warn --fatal-warnings

GDB_PORT ?= 3333
#############################################################
# This Section is for uploading a program to SPI Flash
#############################################################
OPENOCDCFG = ../../risc-v/board/$(BOARD)/openocd.cfg
OPENOCDARGS += -f $(OPENOCDCFG)

GDB_UPLOAD_ARGS = --batch

GDB_UPLOAD_CMDS += -ex "set remotetimeout 240"
GDB_UPLOAD_CMDS += -ex "target extended-remote localhost:$(GDB_PORT)"
GDB_UPLOAD_CMDS += -ex "monitor reset halt"
GDB_UPLOAD_CMDS += -ex "monitor flash protect 0 64 last off"
GDB_UPLOAD_CMDS += -ex "load"
GDB_UPLOAD_CMDS += -ex "monitor resume"
GDB_UPLOAD_CMDS += -ex "monitor shutdown"
GDB_UPLOAD_CMDS += -ex "quit"

all : hifive1.bin

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" > words/build-info.s

upload:
	$(RISCV_OPENOCD) $(OPENOCDARGS) & \
	$(RISCV_GDB) $(PROGRAM_DIR)/$(PROGRAM) $(GDB_UPLOAD_ARGS) $(GDB_UPLOAD_CMDS) && \
	echo "Successfully uploaded '$(PROGRAM)' to $(BOARD)."

hifive1.o: buildinfo
	$(RISCV_TOOLS)-as -I ../../risc-v hifive1.s -o hifive1.o -march=rv32im

hifive1.bin : memmap hifive1.o
	$(RISCV_TOOLS)-ld -o hifive1.elf -T memmap  hifive1.o -m elf32lriscv
	$(RISCV_TOOLS)-objdump -D  hifive1.elf >  hifive1.list
	$(RISCV_TOOLS)-objcopy  hifive1.elf  hifive1.bin -O binary
	$(RISCV_TOOLS)-objcopy  hifive1.elf  hifive1.hex -O ihex

clean:
	rm -f *.bin
	rm -f *.hex
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f words/build-info.s
