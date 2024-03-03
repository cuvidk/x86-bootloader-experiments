# https://en.wikibooks.org/wiki/QEMU/Debugging_with_QEMU
set architecture i8086
add-symbol-file ./bin/triangle.dbg.o 0x7c00
add-symbol-file ./bin/draw-utils.dbg.o 0x7c50
add-symbol-file ./bin/boot-utils.dbg.o 0x7d50
target remote | qemu-system-i386 -S -gdb stdio -drive format=raw,file=./bin/triangle.bin
layout src
br *0x7C00
