.code16

.extern _initialize
.extern _set_video_mode
.extern _set_active_page
.extern _put_c_string

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

	# draw a line in the middle of the screen
	mov $0, %ax
	mov $240, %bx
draw_line:
	call _put_pixel
	inc %ax
	cmp $640, %ax
	jb draw_line

	# loop infinitely
	jmp .

.section .data

my_string:
	.string "Wait what??"
