set architecture i8086
add-symbol-file ./bin/boot.dbg.o 0x7c00
add-symbol-file ./bin/boot-utils.dbg.o 0x7d00
target remote | qemu-system-i386 -S -gdb stdio -drive format=raw,file=./bin/boot.bin
layout src
br *0x7C00

