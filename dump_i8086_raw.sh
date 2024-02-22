#!/bin/sh

OBJDUMP="/usr/bin/objdump"

if [ -z "${1}" ] ;then
	echo "Usage: ${0} <raw_binary_file>"
	exit 1
fi


if [ "${2}" = 'intel' ]; then
	${OBJDUMP} -D -mi386 -Mintel -M i8086 -b binary "${1}"
else
	${OBJDUMP} -D -mi386 -M i8086 -b binary "${1}"
fi
