AS = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-as
LD = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-ld
OBJCOPY = build-tools/x86_64-elf-cross/install/bin/x86_64-elf-objcopy

all: boot.bin

boot.o:
	mkdir -p ./bin
	$(AS) -o ./bin/boot-utils.o ./src/boot-utils.s
	$(AS) -o ./bin/boot.o ./src/boot.s
	$(AS) -g -o ./bin/boot.dbg.o ./src/boot.s
	$(AS) -g -o ./bin/boot-utils.dbg.o ./src/boot-utils.s

boot.bin: boot.o
	$(LD) -T boot.ld --oformat=binary -o ./bin/boot.bin ./bin/boot.o ./bin/boot-utils.o

clean:
	rm -rf ./bin/*
