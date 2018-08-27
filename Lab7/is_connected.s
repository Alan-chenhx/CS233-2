.text

## bool is_connected(unsigned int pos1, unsigned int pos2,
##                   unsigned int* origins) {
##     return get_origin(pos1, origins) == get_origin(pos2, origins);
## }

.globl is_connected
is_connected:
	# Your code goes here :)
	sub 	$sp, $sp, 20
	sw 	$ra, 0($sp)	#ra = sp(0)
	sw 	$a0, 4($sp)	#pos1 = sp(4)
	sw 	$a1, 8($sp)	#pos2 = sp(8)
	sw 	$a2, 12($sp) 	#origin = sp(12)

	lw 	$a0, 4($sp) 	#a0 = pos1
	lw 	$a1, 12($sp) 	#a1 = origin
	jal 	get_origin
	move 	$t1, $v0
	sw 	$t1, 16($sp) 	#store LHS get_origin on stk(16)

	lw 	$a0, 8($sp)	#a0 = pos2
	lw 	$a1, 12($sp) 	#a1 = origin
	jal 	get_origin
	move 	$t2, $v0 	#RHS get_origin = t2

	lw 	$t1, 16($sp) 	#LHS get_origin = t1

	seq 	$v0, $t1, $t2
	lw 	$ra, 0($sp) 	#restore ra
	add 	$sp, $sp, 20 	#reset stk
	jr	$ra
