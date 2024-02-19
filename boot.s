.code16
.globl _start

_start:
.include "./boot-utils.s"
	mov $my_string, %si
	call _put_c_string
	jmp .

my_string:
	.string "Wait what??"

.fill 510 - (. - _start), 1, 0
.byte 0x55
.byte 0xAA
