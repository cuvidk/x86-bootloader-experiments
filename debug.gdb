set architecture i8086
add-symbol-file boot.dbg.o 0x7c00
target remote | qemu-system-i386 -S -gdb stdio -drive format=raw,file=./boot.bin
layout src
