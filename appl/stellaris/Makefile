

stellaris.hex: stellaris.asm ../../msp430/*
	naken_asm -I words \
	  -I ../../msp430/devices/msp430g2553 \
	  -I ../../msp430 \
	  -I ../../common stellaris.asm \
	  -o stellaris.hex -l


stellaris: stellaris.hex
	mspdebug rf2500 "prog stellaris.hex "

clean:
	rm stellaris.hex stellaris.lst

upload: stellaris
