/* squeeze all the code in a boot sector */

SECTIONS {
	.boot 0x7C00 : {	
		./bin/boot.o (.text);
		. = 0x100;
		./bin/boot-utils.o (.text);
		./bin/boot.o (.data);
		. = 0x200 - 2;
		BYTE(0x55);
		BYTE(0xAA);
	} = 0x00
};
