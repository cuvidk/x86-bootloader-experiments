.code16

.extern _set_video_mode
.extern _set_active_page
.extern _draw_triangle

.section .text

.globl _start
_start:
	# setup a stack so we can use call / ret instructions
	cli              # ensure no HW interrupt will execute between the following 2 lines
	xor %ax, %ax
	mov %ax, %ss
	mov $0x8c00, %sp # setup stack 0x1000 bytes further away from ower bootloader code
	sti              # enable interrupts back
	
	# setup ds to 1st segment
	mov $0x0000, %ax
	mov %ax, %ds
	cld

	# set video mode to 0x12 (graphics mode)
	# 12h = G  80x30  8x16  640x480   16/256K  .   A000 VGA,ATI VIP
	mov $0x12, %al
	call _set_video_mode

	# set current active page to 0
	mov $0x00, %al
	call _set_active_page


	# triangle points provided through the stack
	pushw $320
	pushw $40
	pushw $40
	pushw $340
	pushw $600
	pushw $340
	call _draw_triangle

	# loop infinitely
	jmp .
