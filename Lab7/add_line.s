.text

## void add_line(unsigned int start_pos, unsigned int end_pos,
##               unsigned int* canvas, unsigned int* origins) {
##     int step_size = 1;
##     // Check if the line is vertical.
##     if (!((start_pos ^ end_pos) & 31)) {
##         step_size = 32;
##     }
##     if (start_pos > end_pos) {
##         step_size *= -1;
##     }
##     // Update the origin map.
##     add_dot(end_pos, canvas);
##     for (int i = start_pos; i != end_pos; i += step_size) {
##         add_dot(i, canvas);
##         origins[get_origin(i + step_size, origins)] = get_origin(i, origins);
##     }
## }

.globl add_line
add_line:
	# Your code goes here :)
	sub	$sp, $sp, 28	#stk
	sw 	$ra, 0($sp)	#ra
	sw 	$s0, 4($sp) 	#start_pos
	sw 	$s1, 8($sp) 	#end_pos
	sw 	$s2, 12($sp) 	#canvas
	sw 	$s3, 16($sp) 	#origin
	sw 	$s4, 20($sp)	#set t0= step_size
	sw 	$s5, 24($sp)	# $s5 = i

	move 	$s0, $a0	#start_pos
	move 	$s1, $a1	#end_pos
	move 	$s2, $a2	#canvas
	move 	$s3, $a3	#origins
	li 	$s4, 1		#step_size


first_if:
	xor 	$t0, $s0, $s1 	#t0 = start_pos^end_pos
	and 	$t0, $t0, 31 	#t0 = t3 & 31
	bnez 	$t0, second_if 	#now $t3 can be freed
	li 	$s4, 32		#set step_size = 32

second_if:
	ble 	$s0, $s1, else
	neg 	$s4, $s4 	#step_size *= -1

else:
	move 	$a0, $s1 	# $a0 = end_pos
	move 	$a1, $s2 	# $a1 = canvas
	jal 	add_dot

 	move 	$s5, $s0	 # $s5 = $s0 = i
loop:
	beq 	$s5, $s1, done
	move 	$a0, $s5 	# $a0 = i, $a1 = canvas
	move 	$a1, $s2 	# $a1 = canvas
	jal 	add_dot

##RHS
	move 	$a0, $s5	# a0 = i
	move 	$a1, $s3	# a1 = origin
	jal 	get_origin
	move 	$t2, $v0 	#move v0 to t2 since t2 won't be used in get_origin
##LHS
	add 	$a0, $s5, $s4 	# a0 = i + step_size
	jal 	get_origin
	move 	$t3, $v0	#origins[index], index = t3
	sll 	$t3, $t3, 2 	# offset of index
	add 	$t3, $t3, $s3
	sw 	$t2, 0($t3) 	#finished

	add 	$s5, $s5, $s4 	# i += step_size
	j 	loop



done:
	lw 	$ra, 0($sp)
	add 	$sp, $sp, 28
	jr 	$ra
