# 2020-12-02 amforth/erwaelde
# ./test/Makefile

# --- important variables
SHELL=/bin/bash
#     tricky, GNU make can do this:
export PATH := $(shell pwd)/bin:$(PATH)

# --- target board
TARGET  := avr8-at644p
CONSOLE := /dev/ttyUSB0



.PHONY: help
help:
	@(echo "options:" ;\
	  echo "targets: avr8-at644p ..." ;\
	  echo "make firmware [TARGET=...]           # -- assemble firmware for TARGET" ;\
	  echo "make firmware-install [TARGET=...]   # -- install firmware on TARGET" ;\
	)

.PHONY: list
list:
	@echo "target boards:"
	@(cd firmware && ls -1 . | sed 's/^/    /')
	@echo "test files:"
	@echo "./common"
	@(cd cases/common && find . -type f -name \*\.f\* | sed 's/^/    /')
	@echo "./avr8"
	@(cd cases/avr8   && find . -type f -name \*\.f\* | sed 's/^/    /')


.PHONY: firmware
firmware:
	@echo "assembling firmware ($(TARGET))"
	( cd ./firmware/$(TARGET) && $(MAKE) $(MFLAGS) -f Makefile firmware )



.PHONY: firmware-install
firmware-install: firmware
	@echo "installing firmware ($(TARGET))"
	@echo "PROGRAMMER=$(PROGRAMMER)"
	( cd ./firmware/$(TARGET) && $(MAKE) $(MFLAGS) -f Makefile firmware-install )

.PHONY: upload-tester
upload-tester:
	@echo "uploading Forth code ($(TARGET))"
	( cd ./firmware/$(TARGET) && $(MAKE) $(MFLAGS) -f Makefile upload-tester )


.PHONY: test
test:
	@echo "first manual type tests"
	cat ./cases/common/t_arithmetic.fs ./cases/common/double/t_2over.frt | fs.unfold | fs.del_require | fs.trim > ./tmp/unit-test.fs
	./bin/amforth-upload-4.0.py  -t ${CONSOLE} ./tmp/unit-test.fs |& tee ./tmp/unit-test.log
	./bin/grok-test-log.pl tmp/unit-test.log

