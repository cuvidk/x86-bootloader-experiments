/* squeeze all the code in a boot sector */

SECTIONS {
	.boot 0x7C00 : {	
		*/boot.o (.text);
		. = 0x150;
		*/boot-utils.o (.text);
		*/boot.o (.data);
		. = 0x200 - 2;
		BYTE(0x55);
		BYTE(0xAA);
	} = 0x00
};
