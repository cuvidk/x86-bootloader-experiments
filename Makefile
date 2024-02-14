AS = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-as
LD = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-ld
OBJCOPY = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-objcopy

all: boot.bin

boot.o:
	# generate an x86-64 elf binary
	$(AS) -o boot.o boot.s
	# same thing but w/ debugging symbols
	$(AS) -g -o boot.dbg.o boot.s

boot.bin: boot.o
	# $(OBJCOPY) -O binary -j .text boot.o boot.bin
	$(LD) --oformat=binary -o boot.bin boot.o

clean:
	rm -rf boot.o
	rm -rf boot.dbg.o
	rm -rf init.o
	rm -rf boot.bin
