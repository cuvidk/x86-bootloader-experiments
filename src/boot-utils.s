.code16
.section .text

# parameter passing convention:
# if values are 1 byte long use al, bl, cl, dl
# if values are 2 byte long use ax, bx, cx, dx
# etc

###################################################################

.globl _set_active_page
.type _set_active_page, @function
_set_active_page:
	mov $0x05, %ah
	int $0x10
	# save active page in %dl before calling next interrupt
	mov %al, %dl
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
.type _set_video_mode, @function
_set_video_mode:
	# cache this into %dl
	mov %al, %dl
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
	# cache the character in %dl
	mov %al, %dl

	# get active page in bh reg
	mov $0x0F, %ah
	int $0x10

	mov %dl, %al
	mov $0x0E, %ah
	mov $0x00, %bl
	int $0x10
	ret

###################################################################

.globl _put_pixel
.type _put_pixel, @function
_put_pixel:
	pusha
	# column
	mov %ax, %cx
	# row
	mov %bx, %dx
	# get active page in %bh
	mov $0x0F, %ah
	int $0x10
	# color
	mov $0x02, %al
	# video - write graphics pixel
	mov $0x0C, %ah
	int $0x10
	popa
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
	call _put_char
	jmp loop_put_c_string
end_put_c_string:
	ret	

###################################################################

.globl _error
.type _error, @function
_error:
	mov $0xBAD0, %ax
	cli
	hlt

###################################################################
