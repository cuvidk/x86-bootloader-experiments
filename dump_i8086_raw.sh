#!/bin/sh

OBJDUMP="/usr/bin/objdump"

if [ -z "${1}" ] ;then
	echo "Usage: ${0} <raw_binary_file>"
	exit 1
fi

 ${OBJDUMP} -D -mi386 -M i8086 -b binary "${1}"
