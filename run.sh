#!/bin/sh

OUT_DIR="${OUT_DIR:=./bin}"

qemu-system-x86_64 -drive format=raw,file=${OUT_DIR}/boot.bin
