CROSS_COMPILER_DIR ?= ./build-tools/x86_64-elf-cross/install
SRC_DIR ?= .
OUT_DIR ?= ../bin
CROSS_COMPILER_BINARIES = $(CROSS_COMPILER_DIR)/bin

AS = $(CROSS_COMPILER_BINARIES)/x86_64-elf-as
LD = $(CROSS_COMPILER_BINARIES)/x86_64-elf-ld

all: triangle.bin

debug: triangle.dbg triangle.bin

triangle.o:
	$(AS) -o $(OUT_DIR)/boot-utils.o $(SRC_DIR)/boot-utils.s
	$(AS) -o $(OUT_DIR)/draw-utils.o $(SRC_DIR)/draw-utils.s
	$(AS) -o $(OUT_DIR)/triangle.o $(SRC_DIR)/triangle.s

triangle.dbg:
	$(AS) -g -o $(OUT_DIR)/triangle.dbg.o $(SRC_DIR)/triangle.s
	$(AS) -g -o $(OUT_DIR)/draw-utils.dbg.o $(SRC_DIR)/draw-utils.s
	$(AS) -g -o $(OUT_DIR)/boot-utils.dbg.o $(SRC_DIR)/boot-utils.s

triangle.bin: triangle.o
	$(LD) -T $(SRC_DIR)/triangle.ld --oformat=binary -o $(OUT_DIR)/triangle.bin $(OUT_DIR)/triangle.o $(OUT_DIR)/boot-utils.o $(OUT_DIR)/draw-utils.o

clean:
	rm -rf $(OUT_DIR)/*
