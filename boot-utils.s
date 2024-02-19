# my convention: pass parameters using the dx register (dl 1st, dh 2nd)

jmp _initialize

###################################################################

.globl _set_active_page
_set_active_page:
	mov %dl, %al
	mov $0x05, %ah
	int $0x10
	# verify if setting the active page worked
	mov $0x0F, %ah
	int $0x10	
	# interrupt returns active page in bh
	# and required page is in %dl
	cmp %dl, %bh
	jne _error
	ret

###################################################################

.globl _set_video_mode
_set_video_mode:
	mov %dl, %al
	mov $0x00, %ah
	int $0x10
	# verify if setting the video mode was successfull
	cmp $0x06, %dl
	je video_mode_six_chk
	cmp $0x07, %dl
	jg video_mode_gt_seven_chk
	# not 6 and not greater than 7 (0-5 or 7)
video_mode_chk:
	cmp $0x30, %al
	jne _error
	jmp set_video_mode_success
video_mode_six_chk:
	cmp $0x3F, %al
	jne _error
	jmp set_video_mode_success
video_mode_gt_seven_chk:
	cmp $0x20, %al
	jne _error
set_video_mode_success:
	ret

###################################################################

.globl _put_char
.type _put_char, @function
_put_char:
	# get active page in bh reg
	mov $0x0F, %ah
	int $0x10

	mov %dl, %al
	mov $0x0E, %ah
	mov $0x00, %bl
	int $0x10
	ret

###################################################################

.globl _put_c_string
.type _put_c_string, @function
# expect pointer to cstring in ds:si
_put_c_string:
	cld
loop_put_c_string:
	lodsb
	cmp $0x00, %al
	je end_put_c_string
	mov %al, %dl
	call _put_char
	jmp loop_put_c_string
end_put_c_string:
	ret	

###################################################################

.globl _error
_error:
	mov $0x0BAD, %ax
	cli
	hlt

###################################################################

.globl _initialize
_initialize:
	# setup a stack so we can use call / ret instructions
	cli # ensure no HW interrupt will execute between the following 2 lines
	xor %ax, %ax
	mov %ax, %ss
	mov $0x8c00, %sp # setup stack 0x1000 bytes further away from ower bootloader code
	sti # enable interrupts back

	# setup ds to 1st segment
	mov $0x00, %ax
	mov %ax, %ds
	cld

	# set video mode to 3
	mov $0x03, %dl
	call _set_video_mode

	# set current active page to 0
	mov $0x00, %dl
	call _set_active_page
