.code16

.globl _start
_start:
.include "./init.s"
	mov $'!', %dl
	call _put_char
	mov $'K', %dl
	call _put_char
	jmp .

.fill 510 - (. - _start), 1, 0
.byte 0x55
.byte 0xAA
