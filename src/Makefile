CROSS_COMPILER_DIR ?= ./build-tools/x86_64-elf-cross/install
SRC_DIR ?= .
OUT_DIR ?= ../bin
CROSS_COMPILER_BINARIES = $(CROSS_COMPILER_DIR)/bin

AS = $(CROSS_COMPILER_BINARIES)/x86_64-elf-as
LD = $(CROSS_COMPILER_BINARIES)/x86_64-elf-ld

all: boot.bin

boot.o:
	$(AS) -o $(OUT_DIR)/boot-utils.o $(SRC_DIR)/boot-utils.s
	$(AS) -o $(OUT_DIR)/boot.o $(SRC_DIR)/boot.s
	$(AS) -g -o $(OUT_DIR)/boot.dbg.o $(SRC_DIR)/boot.s
	$(AS) -g -o $(OUT_DIR)/boot-utils.dbg.o $(SRC_DIR)/boot-utils.s

boot.bin: boot.o
	$(LD) -T $(SRC_DIR)/boot.ld --oformat=binary -o $(OUT_DIR)/boot.bin $(OUT_DIR)/boot.o $(OUT_DIR)/boot-utils.o

clean:
	rm -rf $(OUT_DIR)/*
