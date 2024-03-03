.code16
.global _draw_triangle
.type _draw_triangle, @function
_draw_triangle:
	popw %ax
	popw c_y
	popw c_x
	popw b_y
	popw b_x
	popw a_y
	popw a_x
	push %ax

	# https://math.stackexchange.com/questions/51326/determining-if-an-arbitrary-point-lies-inside-a-triangle-defined-by-three-points
	# compute vec AB
	mov $a_x, %ax
	mov $b_x, %bx
	mov $ab_x, %cx
	call make_vector

	# compute vec BC
	mov $b_x, %ax
	mov $c_x, %bx
	mov $bc_x, %cx
	call make_vector

	# compute vec CA
	mov $c_x, %ax
	mov $a_x, %bx
	mov $ca_x, %cx
	call make_vector

# %si holds rows
# %di holds cols
loop_next_row:
	mov p_y, %cx
	incw p_y
	cmpw $480, p_y
	je draw_triangle_end
	movw $-1, p_x
loop_next_col:
	incw p_x
	cmpw $640, p_x
	je loop_next_row

	# compute vec AP
	mov $a_x, %ax
	mov $p_x, %bx
	mov $ap_x, %cx
	call make_vector

	# compute vec BP
	mov $b_x, %ax
	mov $p_x, %bx
	mov $bp_x, %cx
	call make_vector

	# compute vec CP
	mov $c_x, %ax
	mov $p_x, %bx
	mov $cp_x, %cx
	call make_vector

	# cross AB X AP
	mov $ab_x, %ax
	mov $ap_x, %bx
	call cross_vector_negative

	mov %al, last

	# cross BC X BP
	mov $bc_x, %ax
	mov $bp_x, %bx
	call cross_vector_negative

	cmp last, %al
	jne loop_next_col

	# cross CA X CP
	mov $ca_x, %ax
	mov $cp_x, %bx
	call cross_vector_negative

	cmp last, %al
	jne loop_next_col

	# draw the pixel
	mov p_x, %ax
	mov p_y, %bx
	call _put_pixel

	jmp loop_next_col
draw_triangle_end:
	ret


# normalizes a vector
make_vector:
	mov %cx, %di # addr of output vec AB
				 # addr of point B is already in %bx
	mov %ax, %bp # addr of point A
	mov (%bx), %ax # b.x into ax
	sub (%bp), %ax # sub a.x from b.x
	movw %ax, (%di) # store b.x - a.x into ab.x
	movw 2(%bx), %ax
	sub 2(%bp), %ax
	movw %ax, 2(%di)
	ret

# Computes the 3rd component of a vector cross product. To be
# used in conjuction with _draw_triangle to determine whether
# a point belongs to the triangle.
# AB X AP
# (x1, x2, 0) X (x2, y2, 0)         = (0, 0, x1 * y2 - x2 * y1)
# (AB.x, AB.y, 0) X (AP.x, AP.y, 0) = (0, 0, AB.x * AP.y - AP.x * AB.y)
cross_vector_negative:
	mov %ax, %bp   # %bp stores addr of AB vec
				   # %bx stores addr of AP vec

	mov (%bx), %ax  # load %ax w/ AP.x
	imulw 2(%bp)    # multiply %ax by AB.y 

	# save result in %SI:%DI
	mov %dx, %si
	mov %ax, %di

	mov (%bp), %ax  # load %ax w/ AB.x
	imulw 2(%bx)    # multiply %ax by AP.y

	sub %di, %ax
	sbb %si, %dx
	
	js is_negative
	mov $0, %al # ret 0 is unsigned
	jmp cross_vec_is_negative_end
is_negative:
	mov $1, %al # ret 1 if signed
cross_vec_is_negative_end:
	ret
	

.section .data

a_x: .word 0
a_y: .word 0
b_x: .word 0
b_y: .word 0
c_x: .word 0
c_y: .word 0

ab_x: .word 0
ab_y: .word 0
bc_x: .word 0
bc_y: .word 0
ca_x: .word 0
ca_y: .word 0

p_x: .word -1
p_y: .word -1

ap_x: .word 0
ap_y: .word 0
bp_x: .word 0
bp_y: .word 0
cp_x: .word 0
cp_y: .word 0

last: .byte 0

